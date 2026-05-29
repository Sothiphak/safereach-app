import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../models/emergency_service.dart';
import '../../widgets/app_filter_chip.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/service_card.dart';
import '../../utils/translations.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  bool _openNow = false;
  bool _shortDistance = false;
  bool _highRating = false;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby services'.tr(context)),
      ),
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
          var services = (snapshot.data ?? [])
            ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
          if (_openNow) {
            services = services.where((service) => service.openNow).toList();
          }
          if (_shortDistance) {
            services = services.where((service) => service.distanceKm <= 3).toList();
          }
          if (_highRating) {
            services = services.where((service) => service.rating >= 4.5).toList();
          }

          if (services.isEmpty) {
            return EmptyState(
              title: 'No nearby services'.tr(context),
              message: 'Adjust filters to see more results.'.tr(context),
              icon: Icons.near_me_outlined,
            );
          }

          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    AppFilterChip(
                      label: 'Open now'.tr(context),
                      selected: _openNow,
                      onSelected: (value) => setState(() => _openNow = value),
                      icon: Icons.schedule,
                    ),
                    const SizedBox(width: 8),
                    AppFilterChip(
                      label: '≤ 3 km'.tr(context),
                      selected: _shortDistance,
                      onSelected: (value) => setState(() => _shortDistance = value),
                      icon: Icons.pin_drop,
                    ),
                    const SizedBox(width: 8),
                    AppFilterChip(
                      label: '4.5+ rating'.tr(context),
                      selected: _highRating,
                      onSelected: (value) => setState(() => _highRating = value),
                      icon: Icons.star,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
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
                          onTap: () => context.go('/home/service/${service.id}'),
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
