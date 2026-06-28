import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/emergency_repository.dart';
import '../../models/emergency_service.dart';
import '../../models/service_type.dart';
import '../../utils/launcher.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/service_card.dart';
import '../../widgets/neumorphic_button.dart';
import '../../utils/translations.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key, required this.type});

  final String type;

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  @override
  Widget build(BuildContext context) {
    final repository = context.read<EmergencyRepository>();
    final serviceType = ServiceType.fromJson(widget.type);

    return Scaffold(
      appBar: AppBar(title: Text('${serviceType.label} nearby'.tr(context))),
      body: FutureBuilder<List<EmergencyService>>(
        future: repository.getServicesByType(serviceType),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingShimmer();
          }
          if (snapshot.hasError) {
            return ErrorState(
              title: 'Unable to load services'.tr(context),
              message: 'Please try again later.'.tr(context),
              onRetry: () => setState(() {}),
            );
          }
          final services = (snapshot.data ?? [])
            ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
          final nearest = services.take(5).toList();
          if (nearest.isEmpty) {
            return EmptyState(
              title: 'No ${serviceType.label} services'.tr(context),
              message: 'Try another category or check back soon.'.tr(context),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: nearest.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final service = nearest[index];
              return ServiceCard(
                service: service,
                onTap: () => context.go('/home/service/${service.id}'),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NeumorphicButton(
                      borderRadius: 12,
                      onTap: () => launchPhone(context, service.phone),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.call, size: 20),
                      ),
                    ),
                    const SizedBox(height: 8),
                    NeumorphicButton(
                      borderRadius: 12,
                      onTap: () => launchDirections(
                        context,
                        latitude: service.latitude,
                        longitude: service.longitude,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.directions, size: 20),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
