import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import '../../data/mock_repository.dart';
import '../../models/emergency_service.dart';
import '../../models/service_type.dart';
import '../../utils/launcher.dart';
import '../../utils/translations.dart';
import '../../state/location_state.dart';
import '../../widgets/app_filter_chip.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/neumorphic_button.dart';
import '../../widgets/service_card.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  ServiceType? _selectedType;
  bool _openNow = false;
  bool _shortDistance = false;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();
    final locationState = context.watch<LocationState>();
    final userPosition = locationState.currentPosition;

    return Scaffold(
      appBar: AppBar(title: Text('Nearby services'.tr(context))),
      body: FutureBuilder<List<EmergencyService>>(
        future: repository.getServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingShimmer();
          }
          if (snapshot.hasError) {
            return ErrorState(
              title: 'Unable to load nearby'.tr(context),
              message: 'Please try again later.'.tr(context),
              onRetry: () => setState(() {}),
            );
          }
          
          final rawServices = snapshot.data ?? [];
          var services = rawServices.map((service) {
            final distance = const Distance().as(
              LengthUnit.Kilometer,
              userPosition,
              LatLng(service.latitude, service.longitude),
            );
            // Parse distance to double with single decimal digit precision
            final distanceVal = double.parse(distance.toStringAsFixed(1));
            return service.copyWith(distanceKm: distanceVal);
          }).toList();

          services.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

          if (_selectedType != null) {
            services = services
                .where((service) => service.type == _selectedType)
                .toList();
          }
          if (_openNow) {
            services = services.where((service) => service.openNow).toList();
          }
          if (_shortDistance) {
            services = services
                .where((service) => service.distanceKm <= 3)
                .toList();
          }

          return Column(
            children: [
              _NearbyHeader(resultCount: services.length),
              _FilterRow(
                selectedType: _selectedType,
                openNow: _openNow,
                shortDistance: _shortDistance,
                onTypeChanged: (type) => setState(() => _selectedType = type),
                onOpenNowChanged: (value) =>
                    setState(() => _openNow = value),
                onShortDistanceChanged: (value) =>
                    setState(() => _shortDistance = value),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sorted by nearest distance'.tr(context),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              Expanded(
                child: services.isEmpty
                    ? EmptyState(
                        title: 'No nearby services'.tr(context),
                        message: 'Adjust filters to see more results.'.tr(
                          context,
                        ),
                        icon: Icons.near_me_outlined,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 450),
                            tween: Tween(begin: 0, end: 1),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 16 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ServiceCard(
                                service: service,
                                onTap: () => context.go(
                                  '/home/service/${service.id}',
                                ),
                                trailing: _NearbyActions(service: service),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NearbyHeader extends StatelessWidget {
  const _NearbyHeader({required this.resultCount});

  final int resultCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Current location: Phnom Penh, BKK1'.tr(context),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            '$resultCount found'.tr(context),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.selectedType,
    required this.openNow,
    required this.shortDistance,
    required this.onTypeChanged,
    required this.onOpenNowChanged,
    required this.onShortDistanceChanged,
  });

  final ServiceType? selectedType;
  final bool openNow;
  final bool shortDistance;
  final ValueChanged<ServiceType?> onTypeChanged;
  final ValueChanged<bool> onOpenNowChanged;
  final ValueChanged<bool> onShortDistanceChanged;

  @override
  Widget build(BuildContext context) {
    final typeChips = <Widget>[
      AppFilterChip(
        label: 'All'.tr(context),
        selected: selectedType == null,
        onSelected: (_) => onTypeChanged(null),
        icon: Icons.apps,
      ),
      for (final type in ServiceType.values) ...[
        const SizedBox(width: 8),
        AppFilterChip(
          label: type.label.tr(context),
          selected: selectedType == type,
          onSelected: (_) => onTypeChanged(type),
          icon: type.icon,
          selectedColor: type.color,
        ),
      ],
    ];

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: typeChips),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Row(
            children: [
              AppFilterChip(
                label: 'Open now'.tr(context),
                selected: openNow,
                onSelected: onOpenNowChanged,
                icon: Icons.schedule,
              ),
              const SizedBox(width: 8),
              AppFilterChip(
                label: 'Within 3 km'.tr(context),
                selected: shortDistance,
                onSelected: onShortDistanceChanged,
                icon: Icons.pin_drop,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NearbyActions extends StatelessWidget {
  const _NearbyActions({required this.service});

  final EmergencyService service;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: 'Call ${service.name}',
          button: true,
          child: NeumorphicButton(
            borderRadius: 12,
            onTap: () => launchPhone(context, service.phone),
            child: const Padding(
              padding: EdgeInsets.all(7),
              child: Icon(Icons.call, size: 21),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'Directions to ${service.name}',
          button: true,
          child: NeumorphicButton(
            borderRadius: 12,
            onTap: () => launchDirections(
              context,
              latitude: service.latitude,
              longitude: service.longitude,
            ),
            child: const Padding(
              padding: EdgeInsets.all(7),
              child: Icon(Icons.directions, size: 21),
            ),
          ),
        ),
      ],
    );
  }
}
