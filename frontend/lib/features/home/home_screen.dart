import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../models/emergency_service.dart';
import '../../models/personal_contact.dart';
import '../../models/service_type.dart';
import '../../state/contacts_state.dart';
import '../../state/favorites_state.dart';
import '../../state/settings_state.dart';
import '../../utils/launcher.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/section_header.dart';
import '../../widgets/service_card.dart';
import '../../widgets/sos_button.dart';
import '../../widgets/neumorphic_container.dart';
import '../../widgets/neumorphic_button.dart';
import '../../utils/translations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  // SOS Countdown overlay state
  bool _showSosCountdown = false;
  int _countdownSeconds = 3;
  Timer? _countdownTimer;
  bool _sosTriggered = false;
  EmergencyService? _selectedSosService;

  @override
  void dispose() {
    _searchController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _chooseSosService(List<EmergencyService> services) async {
    final selectedService = await showModalBottomSheet<EmergencyService>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        final options = _nearestServicesByType(services);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose emergency type'.tr(context),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'SafeReach will call the nearest matching service after the countdown.'
                      .tr(context),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final service = options[index];
                      final type = service.type;

                      return NeumorphicButton(
                        borderRadius: 18,
                        onTap: () => Navigator.of(context).pop(service),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: type.color.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(type.icon, color: type.color),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      type.label.tr(context),
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                          ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${service.name.tr(context)} • ${service.distanceKm.toStringAsFixed(1)} km',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.chevron_right,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selectedService == null) {
      return;
    }

    _startSosCountdown(selectedService);
  }

  List<EmergencyService> _nearestServicesByType(
    List<EmergencyService> services,
  ) {
    final options = <EmergencyService>[];
    for (final type in ServiceType.values) {
      final matches = services.where((service) => service.type == type).toList()
        ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      if (matches.isNotEmpty) {
        options.add(matches.first);
      }
    }
    return options;
  }

  String _responseUnitLabel(ServiceType type) {
    return switch (type) {
      ServiceType.police => 'Police unit',
      ServiceType.hospital => 'Medical team',
      ServiceType.fire => 'Fire response team',
      ServiceType.ambulance => 'Ambulance',
      ServiceType.women => 'Support team',
      ServiceType.disaster => 'Relief team',
    };
  }

  void _startSosCountdown(EmergencyService service) {
    setState(() {
      _showSosCountdown = true;
      _countdownSeconds = 3;
      _sosTriggered = false;
      _selectedSosService = service;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_countdownSeconds > 1) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _sosTriggered = true;
        });
        launchPhone(context, service.phone);
      }
    });
  }

  void _cancelSosCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _showSosCountdown = false;
      _sosTriggered = false;
      _selectedSosService = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();
    final theme = Theme.of(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SafeReach'.tr(context),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Emergency Response Hub'.tr(context),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Favorites',
                onPressed: () => context.go('/home/favorites'),
                icon: Icon(Icons.favorite, color: theme.colorScheme.primary),
              ),
              IconButton(
                tooltip: 'First aid tips',
                onPressed: () => context.go('/home/first-aid'),
                icon: const Icon(Icons.medical_services_outlined),
              ),
            ],
          ),
          body: FutureBuilder<List<EmergencyService>>(
            future: repository.getServices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingShimmer();
              }
              if (snapshot.hasError) {
                return ErrorState(
                  title: 'Unable to load services'.tr(context),
                  message: 'Please check your connection and try again.'.tr(
                    context,
                  ),
                  onRetry: () => setState(() {}),
                );
              }
              final services = snapshot.data ?? [];
              if (services.isEmpty) {
                return EmptyState(
                  title: 'No services found'.tr(context),
                  message: 'We could not find emergency services in your area.'
                      .tr(context),
                );
              }

              // Search filtering
              final filtered = services
                  .where(
                    (service) =>
                        service.name.toLowerCase().contains(
                          _query.toLowerCase(),
                        ) ||
                        service.type.label.toLowerCase().contains(
                          _query.toLowerCase(),
                        ) ||
                        service.address.toLowerCase().contains(
                          _query.toLowerCase(),
                        ),
                  )
                  .toList();
              final featured = filtered.take(6).toList();
              final nearestService = services.reduce(
                (current, next) =>
                    current.distanceKm <= next.distanceKm ? current : next,
              );
              final favoritesState = context.watch<FavoritesState>();
              final favoriteServices = services
                  .where((service) => favoritesState.isFavorite(service.id))
                  .toList();

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  // Top Row with location chip and Settings shortcut
                  _EntranceAnimation(
                    delayMs: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Semantics(
                          label: 'Current Location Phnom Penh, BKK1',
                          child: NeumorphicContainer(
                            borderRadius: 20,
                            isPressed: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Phnom Penh, BKK1',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        NeumorphicButton(
                          borderRadius: 28,
                          onTap: () => context.go('/settings'),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.settings,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const _EntranceAnimation(
                    delayMs: 100,
                    child: _OfflineDataBadge(),
                  ),
                  const SizedBox(height: 12),

                  _EntranceAnimation(
                    delayMs: 150,
                    child: _NearestHelpCard(service: nearestService),
                  ),
                  const SizedBox(height: 16),

                  // Giant SOS Section (Big pulsing button)
                  _EntranceAnimation(
                    child: Semantics(
                      label: 'Emergency SOS trigger section',
                      child: NeumorphicContainer(
                        borderRadius: 28,
                        padding: const EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 16,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'IN AN EMERGENCY'.tr(context),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Press the SOS button below to call for help'.tr(
                                context,
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 36),
                            // Pulsing SOS Button
                            SosButton(
                              size: 160,
                              onPressed: () => _chooseSosService(services),
                            ),
                            const SizedBox(height: 36),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary.withValues(
                                  alpha: 0.06,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.colorScheme.secondary.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Activates 3s confirmation window before calling'
                                        .tr(context),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Search Bar
                  _EntranceAnimation(
                    delayMs: 200,
                    child: NeumorphicContainer(
                      borderRadius: 20,
                      isPressed: true,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _query = value),
                        decoration: InputDecoration(
                          hintText:
                              'Search hospitals, police, rescue stations...'.tr(
                                context,
                              ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: theme.colorScheme.primary,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: Colors.transparent,
                          filled: false,
                          suffixIcon: _query.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => setState(() {
                                    _searchController.clear();
                                    _query = '';
                                  }),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4 Quick-Action Tiles Section
                  _EntranceAnimation(
                    delayMs: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Primary Emergency Services'.tr(context),
                        ),
                        const SizedBox(height: 12),
                        _PrimaryQuickActionsGrid(
                          onTap: (type) =>
                              context.go('/home/services/${type.name}'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Other Categories Section
                  _EntranceAnimation(
                    delayMs: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Additional Helplines'.tr(context),
                        ),
                        const SizedBox(height: 12),
                        _SecondaryQuickActionsRow(
                          onTap: (type) =>
                              context.go('/home/services/${type.name}'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Emergency profile card
                  const _EntranceAnimation(
                    delayMs: 500,
                    child: _EmergencyProfileCard(),
                  ),
                  const SizedBox(height: 24),

                  // Featured Nearby list
                  _EntranceAnimation(
                    delayMs: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(title: 'Nearest Help Points'.tr(context)),
                        const SizedBox(height: 12),
                        if (featured.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: EmptyState(
                              title: 'No search results',
                              message:
                                  'Try checking your spelling or search terms.',
                            ),
                          )
                        else
                          ...featured.map(
                            (service) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ServiceCard(
                                service: service,
                                onTap: () =>
                                    context.go('/home/service/${service.id}'),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Favorites Section
                  _EntranceAnimation(
                    delayMs: 700,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Your Saved Services'.tr(context),
                          actionLabel: 'See all'.tr(context),
                          onAction: () => context.go('/home/favorites'),
                        ),
                        const SizedBox(height: 12),
                        if (favoriteServices.isEmpty)
                          const EmptyState(
                            title: 'No saved services',
                            message:
                                'Add services to favorites for instant access here.',
                          )
                        else
                          ...favoriteServices
                              .take(3)
                              .map(
                                (service) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ServiceCard(
                                    service: service,
                                    onTap: () => context.go(
                                      '/home/service/${service.id}',
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),

        // SOS Countdown / Alert Overlay
        if (_showSosCountdown)
          Container(
            color: Colors.black.withValues(alpha: 0.85),
            width: double.infinity,
            height: double.infinity,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_sosTriggered) ...[
                      // Pulsing Red Shield Icon
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 500),
                        tween: Tween(begin: 0.8, end: 1.2),
                        curve: Curves.easeInOut,
                        builder: (context, scale, child) {
                          return Transform.scale(scale: scale, child: child);
                        },
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 100,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'TRIGGERING SOS ALARM'.tr(context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Connecting you to emergency response and transmitting details.'
                            .tr(context),
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      if (_selectedSosService != null) ...[
                        const SizedBox(height: 20),
                        _SosSelectedServiceCard(
                          service: _selectedSosService!,
                          isDarkOverlay: true,
                        ),
                      ],
                      const SizedBox(height: 48),
                      // Huge Countdown Number
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          '$_countdownSeconds',
                          key: ValueKey<int>(_countdownSeconds),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 120,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.gps_fixed,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'SENDING GPS COORDINATES'.tr(context),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Phnom Penh, BKK1 (11.5564° N, 104.9282° E)',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Cancel Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white24,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _cancelSosCountdown,
                          child: Text(
                            'CANCEL SOS'.tr(context),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Success State
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 100,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'SOS ALARM SENT'.tr(context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedSosService == null
                            ? 'Dialing dispatch and routing emergency response.'
                                  .tr(context)
                            : 'Dialing ${_selectedSosService!.name.tr(context)} (${_selectedSosService!.phone}) and routing emergency response.',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          _selectedSosService == null
                              ? 'Mock dispatch status: Ambulance en-route (ETA: 4 mins). Stay where you are.'
                                    .tr(context)
                              : 'Mock dispatch status: ${_responseUnitLabel(_selectedSosService!.type)} en-route (ETA: 4 mins). Stay where you are.',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      // Call Emergency Hotline manually
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _selectedSosService == null
                              ? null
                              : () => launchPhone(
                                  context,
                                  _selectedSosService!.phone,
                                ),
                          icon: const Icon(Icons.phone),
                          label: Text(
                            'DIAL DISPATCH'.tr(context),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Dismiss Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: const BorderSide(color: Colors.white30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _cancelSosCountdown,
                          child: Text('DISMISS OVERLAY'.tr(context)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SosSelectedServiceCard extends StatelessWidget {
  const _SosSelectedServiceCard({
    required this.service,
    this.isDarkOverlay = false,
  });

  final EmergencyService service;
  final bool isDarkOverlay;

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkOverlay ? Colors.white : null;
    final secondaryTextColor = isDarkOverlay ? Colors.white70 : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkOverlay
            ? Colors.white.withValues(alpha: 0.08)
            : service.type.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkOverlay
              ? Colors.white.withValues(alpha: 0.16)
              : service.type.color.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: service.type.color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(service.type.icon, color: service.type.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.type.label.tr(context),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${service.name.tr(context)} • ${service.phone}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: secondaryTextColor, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryQuickActionsGrid extends StatelessWidget {
  const _PrimaryQuickActionsGrid({required this.onTap});

  final ValueChanged<ServiceType> onTap;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 720;
    // Limit to the 4 primary emergency services
    final primaryServices = [
      ServiceType.hospital,
      ServiceType.police,
      ServiceType.fire,
      ServiceType.ambulance,
    ];

    return GridView.count(
      crossAxisCount: isTablet ? 4 : 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: primaryServices.map((type) {
        return NeumorphicButton(
          borderRadius: 20,
          onTap: () => onTap(type),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(type.icon, color: type.color, size: 36),
                const SizedBox(height: 10),
                Text(
                  type.label.tr(context),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SecondaryQuickActionsRow extends StatelessWidget {
  const _SecondaryQuickActionsRow({required this.onTap});

  final ValueChanged<ServiceType> onTap;

  @override
  Widget build(BuildContext context) {
    // Other categories: Women help, Disaster Relief
    final secondaryServices = [ServiceType.women, ServiceType.disaster];

    return Row(
      children: secondaryServices.map((type) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: NeumorphicButton(
              borderRadius: 16,
              onTap: () => onTap(type),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(type.icon, color: type.color, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        type.label.tr(context),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: type.color,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _OfflineDataBadge extends StatelessWidget {
  const _OfflineDataBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        label: 'Offline emergency data available',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.offline_bolt_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Offline emergency data available.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NearestHelpCard extends StatelessWidget {
  const _NearestHelpCard({required this.service});

  final EmergencyService service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label:
          'Nearest help ${service.name}, ${service.distanceKm.toStringAsFixed(1)} kilometers away',
      child: NeumorphicContainer(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: service.type.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(service.type.icon, color: service.type.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nearest help',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${service.name}, ${service.distanceKm.toStringAsFixed(1)} km',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () => launchPhone(context, service.phone),
                      icon: const Icon(Icons.call),
                      label: const Text(
                        'CALL',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => launchDirections(
                        context,
                        latitude: service.latitude,
                        longitude: service.longitude,
                      ),
                      icon: const Icon(Icons.directions),
                      label: const Text(
                        'DIRECTIONS',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyProfileCard extends StatelessWidget {
  const _EmergencyProfileCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsState>();
    final contacts = context.watch<ContactsState>().contacts;
    final primaryContact = contacts.isNotEmpty ? contacts.first : null;
    final bloodGroup = settings.bloodGroup.trim().isEmpty
        ? 'Not set'
        : settings.bloodGroup.trim();
    final allergies = settings.allergies.trim().isEmpty
        ? 'Not set'
        : settings.allergies.trim();

    return NeumorphicContainer(
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      child: Semantics(
        label: 'Emergency profile card with medical details and contact',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.badge_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Profile',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Critical info ready for responders',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/settings'),
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ProfileInfoTile(
                  icon: Icons.bloodtype_outlined,
                  label: 'Blood group',
                  value: bloodGroup,
                ),
                _ProfileInfoTile(
                  icon: Icons.warning_amber_outlined,
                  label: 'Allergies',
                  value: allergies,
                ),
                _ProfileInfoTile(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  value: 'Phnom Penh, BKK1',
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ProfileContactRow(primaryContact: primaryContact),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: () =>
                    _copyEmergencyProfile(context, settings, primaryContact),
                icon: const Icon(Icons.ios_share),
                label: const Text(
                  'SHARE EMERGENCY INFO',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyEmergencyProfile(
    BuildContext context,
    SettingsState settings,
    PersonalContact? primaryContact,
  ) async {
    final bloodGroup = settings.bloodGroup.trim().isEmpty
        ? 'Not set'
        : settings.bloodGroup.trim();
    final allergies = settings.allergies.trim().isEmpty
        ? 'Not set'
        : settings.allergies.trim();
    final contactLine = primaryContact != null
        ? '${primaryContact.name} (${primaryContact.relationship}) - ${primaryContact.phone}'
        : 'Not set';

    await Clipboard.setData(
      ClipboardData(
        text:
            'SafeReach Emergency Profile\n'
            'Location: Phnom Penh, BKK1\n'
            'Blood group: $bloodGroup\n'
            'Allergies: $allergies\n'
            'Emergency contact: $contactLine',
      ),
    );

    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Emergency info copied to clipboard')),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileContactRow extends StatelessWidget {
  const _ProfileContactRow({required this.primaryContact});

  final PersonalContact? primaryContact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contact = primaryContact;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          Icon(Icons.contact_phone_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency contact',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  contact == null
                      ? 'No personal contact added'
                      : '${contact.name} - ${contact.phone}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          if (contact != null)
            IconButton(
              tooltip: 'Call emergency contact',
              onPressed: () => launchPhone(context, contact.phone),
              icon: Icon(Icons.call, color: theme.colorScheme.primary),
            )
          else
            TextButton(
              onPressed: () => context.go('/contacts'),
              child: const Text('Add'),
            ),
        ],
      ),
    );
  }
}

class _EntranceAnimation extends StatefulWidget {
  final Widget child;
  final int delayMs;

  const _EntranceAnimation({required this.child, this.delayMs = 0});

  @override
  State<_EntranceAnimation> createState() => _EntranceAnimationState();
}

class _EntranceAnimationState extends State<_EntranceAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<double>(
      begin: 28.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.delayMs > 0) {
      Future.delayed(Duration(milliseconds: widget.delayMs), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0.0, _slideAnimation.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
