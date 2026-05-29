import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../models/emergency_service.dart';
import '../../models/service_type.dart';
import '../../utils/launcher.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/service_card.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key, required this.type});

  final String type;

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();
    final serviceType = ServiceType.fromJson(widget.type);

    return Scaffold(
      appBar: AppBar(
        title: Text('${serviceType.label} nearby'),
      ),
      body: FutureBuilder<List<EmergencyService>>(
        future: repository.getServicesByType(serviceType),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingShimmer();
          }
          if (snapshot.hasError) {
            return ErrorState(
              title: 'Unable to load services',
              message: 'Please try again later.',
              onRetry: () => setState(() {}),
            );
          }
          final services = (snapshot.data ?? [])
            ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
          final nearest = services.take(5).toList();
          if (nearest.isEmpty) {
            return EmptyState(
              title: 'No ${serviceType.label} services',
              message: 'Try another category or check back soon.',
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
                  children: [
                    IconButton(
                      tooltip: 'Call',
                      icon: const Icon(Icons.call),
                      onPressed: () => launchPhone(context, service.phone),
                    ),
                    IconButton(
                      tooltip: 'Directions',
                      icon: const Icon(Icons.directions),
                      onPressed: () => launchDirections(
                        context,
                        latitude: service.latitude,
                        longitude: service.longitude,
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
