import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../models/emergency_branch.dart';
import '../../utils/launcher.dart';
import '../../widgets/error_state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency map'),
      ),
      body: FutureBuilder<List<EmergencyBranch>>(
        future: repository.getBranches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorState(
              title: 'Unable to load map',
              message: 'Please try again.',
              onRetry: () => setState(() {}),
            );
          }
          final branches = snapshot.data ?? [];
          return FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(11.5564, 104.9282),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.safereach.app',
              ),
              MarkerLayer(
                markers: branches
                    .map(
                      (branch) => Marker(
                        point: LatLng(branch.latitude, branch.longitude),
                        width: 44,
                        height: 44,
                        child: GestureDetector(
                          onTap: () => _showBranchSheet(context, branch),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: branch.type.color,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(branch.type.icon, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showBranchSheet(BuildContext context, EmergencyBranch branch) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(branch.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(branch.address),
              const SizedBox(height: 6),
              Text(branch.phone),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => launchPhone(context, branch.phone),
                      icon: const Icon(Icons.call),
                      label: const Text('Call'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => launchDirections(
                        context,
                        latitude: branch.latitude,
                        longitude: branch.longitude,
                      ),
                      icon: const Icon(Icons.directions),
                      label: const Text('Directions'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
