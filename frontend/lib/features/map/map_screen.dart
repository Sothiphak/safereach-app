import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../models/emergency_branch.dart';
import '../../utils/launcher.dart';
import '../../widgets/error_state.dart';
import '../../widgets/neumorphic_container.dart';
import '../../widgets/neumorphic_button.dart';
import '../../utils/translations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tileUrl = isDark
        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png'
        : 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}@2x.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Map'.tr(context)),
      ),
      body: FutureBuilder<List<EmergencyBranch>>(
        future: repository.getBranches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorState(
              title: 'Unable to load map'.tr(context),
              message: 'Please try again.'.tr(context),
              onRetry: () => setState(() {}),
            );
          }
          final branches = snapshot.data ?? [];
          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(11.5564, 104.9282),
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate: tileUrl,
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
                              onTap: () {
                                _mapController.move(LatLng(branch.latitude, branch.longitude), 14.5);
                                _showBranchSheet(context, branch);
                              },
                              child: NeumorphicContainer(
                                borderRadius: 22,
                                padding: const EdgeInsets.all(4),
                                border: Border.all(color: branch.type.color.withValues(alpha: 0.7), width: 1.5),
                                child: Center(
                                  child: Icon(
                                    branch.type.icon,
                                    color: branch.type.color,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              Positioned(
                bottom: 24,
                right: 16,
                child: Column(
                  children: [
                    NeumorphicButton(
                      borderRadius: 14,
                      onTap: () {
                        final currentZoom = _mapController.camera.zoom;
                        _mapController.move(_mapController.camera.center, currentZoom + 1);
                      },
                      child: const SizedBox(
                        height: 48,
                        width: 48,
                        child: Icon(Icons.add, size: 24),
                      ),
                    ),
                    const SizedBox(height: 12),
                    NeumorphicButton(
                      borderRadius: 14,
                      onTap: () {
                        final currentZoom = _mapController.camera.zoom;
                        _mapController.move(_mapController.camera.center, currentZoom - 1);
                      },
                      child: const SizedBox(
                        height: 48,
                        width: 48,
                        child: Icon(Icons.remove, size: 24),
                      ),
                    ),
                    const SizedBox(height: 12),
                    NeumorphicButton(
                      borderRadius: 14,
                      onTap: () {
                        _mapController.move(const LatLng(11.5564, 104.9282), 13.0);
                      },
                      child: const SizedBox(
                        height: 48,
                        width: 48,
                        child: Icon(Icons.my_location, size: 20),
                      ),
                    ),
                  ],
                ),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: branch.type.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(branch.type.icon, color: branch.type.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          branch.name.tr(context),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          branch.type.label.tr(context).toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            color: branch.type.color,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      branch.address.tr(context),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.phone_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    branch.phone,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: NeumorphicButton(
                      borderRadius: 16,
                      onTap: () => launchPhone(context, branch.phone),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.call, color: branch.type.color, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'CALL'.tr(context),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: branch.type.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: NeumorphicButton(
                      borderRadius: 16,
                      onTap: () => launchDirections(
                        context,
                        latitude: branch.latitude,
                        longitude: branch.longitude,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.directions, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'DIRECTIONS'.tr(context),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
