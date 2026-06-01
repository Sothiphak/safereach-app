import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../models/emergency_service.dart';
import '../../models/service_type.dart';
import '../../state/favorites_state.dart';
import '../../utils/launcher.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/section_header.dart';
import '../../widgets/service_card.dart';
import '../../widgets/sos_button.dart';

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

  @override
  void dispose() {
    _searchController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startSosCountdown() {
    setState(() {
      _showSosCountdown = true;
      _countdownSeconds = 3;
      _sosTriggered = false;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 1) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _sosTriggered = true;
        });
        // Automatically launch emergency call to primary number
        launchPhone(context, '+85523219911');
      }
    });
  }

  void _cancelSosCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _showSosCountdown = false;
      _sosTriggered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SafeReach',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                ),
                Text(
                  'Emergency Response Hub',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.blue[300] : const Color(0xFFB71C1C),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Favorites',
                onPressed: () => context.go('/home/favorites'),
                icon: const Icon(Icons.favorite, color: Color(0xFFD32F2F)),
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
                  title: 'Unable to load services',
                  message: 'Please check your connection and try again.',
                  onRetry: () => setState(() {}),
                );
              }
              final services = snapshot.data ?? [];
              if (services.isEmpty) {
                return const EmptyState(
                  title: 'No services found',
                  message: 'We could not find emergency services in your area.',
                );
              }

              // Search filtering
              final filtered = services
                  .where((service) =>
                      service.name.toLowerCase().contains(_query.toLowerCase()) ||
                      service.type.label.toLowerCase().contains(_query.toLowerCase()) ||
                      service.address.toLowerCase().contains(_query.toLowerCase()))
                  .toList();
              final featured = filtered.take(6).toList();
              final favoritesState = context.watch<FavoritesState>();
              final favoriteServices = services
                  .where((service) => favoritesState.isFavorite(service.id))
                  .toList();

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  // Top Row with location chip and Settings shortcut
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Semantics(
                        label: 'Current Location Phnom Penh, BKK1',
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFD32F2F).withValues(alpha: 0.12),
                            border: Border.all(
                              color: const Color(0xFFD32F2F).withValues(alpha: 0.25),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Color(0xFFD32F2F)),
                              SizedBox(width: 6),
                              Text(
                                'Phnom Penh, BKK1',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD32F2F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        tooltip: 'Settings Screen',
                        onPressed: () => context.go('/settings'),
                        icon: const Icon(Icons.settings),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Giant SOS Section (Big pulsing button)
                  Semantics(
                    label: 'Emergency SOS trigger section',
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'IN AN EMERGENCY',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Color(0xFFD32F2F),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Press the SOS button below to call for help',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 36),
                          // Pulsing SOS Button
                          SosButton(
                            size: 160,
                            onPressed: _startSosCountdown,
                          ),
                          const SizedBox(height: 36),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.info_outline, size: 16, color: Colors.amber),
                                SizedBox(width: 8),
                                Text(
                                  'Activates 3s confirmation window before calling',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber,
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
                  const SizedBox(height: 24),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'Search hospitals, police, rescue stations...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFD32F2F)),
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
                  const SizedBox(height: 24),

                  // 4 Quick-Action Tiles Section
                  SectionHeader(
                    title: 'Primary Emergency Services',
                  ),
                  const SizedBox(height: 12),
                  _PrimaryQuickActionsGrid(
                    onTap: (type) => context.go('/home/services/${type.name}'),
                  ),
                  const SizedBox(height: 24),

                  // Other Categories Section
                  SectionHeader(
                    title: 'Additional Helplines',
                  ),
                  const SizedBox(height: 12),
                  _SecondaryQuickActionsRow(
                    onTap: (type) => context.go('/home/services/${type.name}'),
                  ),
                  const SizedBox(height: 24),

                  // Promotion/Safety tips strip
                  const _PromotionStrip(),
                  const SizedBox(height: 24),

                  // Featured Nearby list
                  SectionHeader(title: 'Nearest Help Points'),
                  const SizedBox(height: 12),
                  if (featured.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: EmptyState(
                        title: 'No search results',
                        message: 'Try checking your spelling or search terms.',
                      ),
                    )
                  else
                    ...featured.map(
                      (service) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ServiceCard(
                          service: service,
                          onTap: () => context.go('/home/service/${service.id}'),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Favorites Section
                  SectionHeader(
                    title: 'Your Saved Services',
                    actionLabel: 'See all',
                    onAction: () => context.go('/home/favorites'),
                  ),
                  const SizedBox(height: 12),
                  if (favoriteServices.isEmpty)
                    const EmptyState(
                      title: 'No saved services',
                      message: 'Add services to favorites for instant access here.',
                    )
                  else
                    ...favoriteServices.take(3).map(
                      (service) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ServiceCard(
                          service: service,
                          onTap: () => context.go('/home/service/${service.id}'),
                        ),
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
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 100,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'TRIGGERING SOS ALARM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Connecting you to emergency response and transmitting details.',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      // Huge Countdown Number
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(scale: animation, child: child);
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
                      // Location Details Transmitting
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.gps_fixed, color: Colors.green, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'SENDING GPS COORDINATES',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
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
                          child: const Text(
                            'CANCEL SOS',
                            style: TextStyle(
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
                      const Text(
                        'SOS ALARM SENT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Dialing dispatch at Calmette Emergency Care (+855 23 218 878) and routing response vehicle.',
                        style: TextStyle(
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
                          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                        ),
                        child: const Text(
                          'Mock dispatch status: Ambulance en-route (ETA: 4 mins). Stay where you are.',
                          style: TextStyle(
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
                            backgroundColor: const Color(0xFFD32F2F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => launchPhone(context, '+85523219911'),
                          icon: const Icon(Icons.phone),
                          label: const Text(
                            'DIAL DISPATCH',
                            style: TextStyle(
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
                          child: const Text('DISMISS OVERLAY'),
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
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onTap(type),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: type.color.withValues(alpha: 0.12),
              border: Border.all(
                color: type.color.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(type.icon, color: type.color, size: 36),
                const SizedBox(height: 10),
                Text(
                  type.label,
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
    final secondaryServices = [
      ServiceType.women,
      ServiceType.disaster,
    ];

    return Row(
      children: secondaryServices.map((type) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onTap(type),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: type.color.withValues(alpha: 0.08),
                  border: Border.all(
                    color: type.color.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(type.icon, color: type.color, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        type.label,
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

class _PromotionStrip extends StatelessWidget {
  const _PromotionStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.health_and_safety, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Safety Tip: Update your personal contacts and input critical medical information like your blood group and allergies in Settings.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
