import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../state/location_state.dart';
import '../../models/emergency_branch.dart';
import '../../models/service_type.dart';
import '../../utils/launcher.dart';
import '../../widgets/error_state.dart';
import '../../widgets/neumorphic_container.dart';
import '../../widgets/neumorphic_button.dart';
import '../../widgets/app_filter_chip.dart';
import '../../utils/translations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _searchQuery = '';
  ServiceType? _selectedCategory;
  bool _showSuggestions = false;
  MapStyle? _customMapStyle;
  EmergencyBranch? _selectedBranch;

  MapStyle _getEffectiveMapStyle(bool isDark) {
    if (_customMapStyle != null) return _customMapStyle!;
    return isDark ? MapStyle.dark : MapStyle.vibrant;
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationState = context.watch<LocationState>();
    final userPosition = locationState.currentPosition;

    final effectiveStyle = _getEffectiveMapStyle(isDark);
    final tileUrl = effectiveStyle.urlTemplate;

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

          // 1. Filter branches based on selected category & search query
          final filteredBranches = branches.where((branch) {
            final categoryMatches = _selectedCategory == null || branch.type == _selectedCategory;
            if (_searchQuery.isEmpty) return categoryMatches;
            final nameMatches = branch.name.tr(context).toLowerCase().contains(_searchQuery.toLowerCase());
            final addressMatches = branch.address.tr(context).toLowerCase().contains(_searchQuery.toLowerCase());
            return (nameMatches || addressMatches) && categoryMatches;
          }).toList();

          // 2. Filter suggestion list based on category & search query
          final suggestionBranches = branches.where((branch) {
            final categoryMatches = _selectedCategory == null || branch.type == _selectedCategory;
            final nameMatches = branch.name.tr(context).toLowerCase().contains(_searchQuery.toLowerCase());
            final addressMatches = branch.address.tr(context).toLowerCase().contains(_searchQuery.toLowerCase());
            return (nameMatches || addressMatches) && categoryMatches;
          }).toList();

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: userPosition,
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate: tileUrl,
                    userAgentPackageName: 'com.safereach.app',
                  ),
                  MarkerLayer(
                    markers: [
                      // User position marker
                      Marker(
                        point: userPosition,
                        width: 26,
                        height: 26,
                        child: _UserLocationIndicator(hasActualLocation: locationState.hasActualLocation),
                      ),
                      ...filteredBranches
                          .map(
                            (branch) => Marker(
                              point: LatLng(branch.latitude, branch.longitude),
                              width: 52,
                              height: 58,
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () {
                                  _mapController.move(LatLng(branch.latitude, branch.longitude), 14.5);
                                  _showBranchSheet(context, branch);
                                },
                                child: MapPin(
                                  color: branch.type.color,
                                  icon: branch.type.icon,
                                  isSelected: _selectedBranch == branch,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ],
              ),
              // Search & Filter Category overlay at top
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search Input field
                    NeumorphicContainer(
                      borderRadius: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Search map...'.tr(context),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                      _showSuggestions = false;
                                    });
                                  },
                                )
                              : null,
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                            _showSuggestions = val.isNotEmpty;
                          });
                        },
                        onTap: () {
                          if (_searchController.text.isNotEmpty) {
                            setState(() {
                              _showSuggestions = true;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Category list chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          AppFilterChip(
                            label: 'All'.tr(context),
                            selected: _selectedCategory == null,
                            onSelected: (_) => setState(() {
                              _selectedCategory = null;
                            }),
                          ),
                          const SizedBox(width: 8),
                          ...ServiceType.values.map((type) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: AppFilterChip(
                                label: type.label.tr(context),
                                selected: _selectedCategory == type,
                                onSelected: (_) => setState(() {
                                  _selectedCategory = type;
                                }),
                                icon: type.icon,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    // Suggestions popup dropdown
                    if (_showSuggestions && _searchQuery.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.3,
                        ),
                        child: NeumorphicContainer(
                          borderRadius: 16,
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: suggestionBranches.isEmpty ? 1 : suggestionBranches.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              if (suggestionBranches.isEmpty) {
                                return ListTile(
                                  title: Text(
                                    'No results found'.tr(context),
                                    style: const TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                );
                              }
                              final branch = suggestionBranches[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: branch.type.color.withValues(alpha: 0.1),
                                  child: Icon(branch.type.icon, color: branch.type.color, size: 18),
                                ),
                                title: Text(branch.name.tr(context)),
                                subtitle: Text(branch.address.tr(context)),
                                onTap: () {
                                  setState(() {
                                    _searchController.text = branch.name.tr(context);
                                    _searchQuery = branch.name.tr(context);
                                    _showSuggestions = false;
                                    _focusNode.unfocus();
                                  });
                                  _mapController.move(LatLng(branch.latitude, branch.longitude), 14.5);
                                  _showBranchSheet(context, branch);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Map Legend relocated to bottom left
              Positioned(
                bottom: 24,
                left: 16,
                child: const _MapLegend(),
              ),
              // Zoom, style, and my location buttons
              Positioned(
                bottom: 24,
                right: 16,
                child: Column(
                  children: [
                    NeumorphicButton(
                      borderRadius: 14,
                      onTap: () {
                        _showMapStyleSheet(context);
                      },
                      child: const SizedBox(
                        height: 48,
                        width: 48,
                        child: Icon(Icons.layers_outlined, size: 22),
                      ),
                    ),
                    const SizedBox(height: 12),
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
                        _mapController.move(userPosition, 13.0);
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
    setState(() {
      _selectedBranch = branch;
    });
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
    ).whenComplete(() {
      setState(() {
        _selectedBranch = null;
      });
    });
  }

  void _showMapStyleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final currentStyle = _getEffectiveMapStyle(isDark);

        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 32, top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Map Style'.tr(context),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: MapStyle.values.map((style) {
                    final isSelected = currentStyle == style;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _customMapStyle = style;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: _getGradientForStyle(style),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                                ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.black.withValues(alpha: 0.6),
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    style.label.tr(context),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  _getIconForStyle(style),
                                  color: Colors.white.withValues(alpha: 0.8),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Gradient _getGradientForStyle(MapStyle style) {
    switch (style) {
      case MapStyle.vibrant:
        return const LinearGradient(
          colors: [Color(0xFFE0F7FA), Color(0xFFFFF9C4), Color(0xFFC8E6C9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case MapStyle.classic:
        return const LinearGradient(
          colors: [Color(0xFFBBDEFB), Color(0xFFE8F5E9), Color(0xFFFFF3E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case MapStyle.dark:
        return const LinearGradient(
          colors: [Color(0xFF121212), Color(0xFF1E1E24), Color(0xFF2C2C35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case MapStyle.satellite:
        return const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case MapStyle.minimal:
        return const LinearGradient(
          colors: [Color(0xFFECEFF1), Color(0xFFF5F7F8), Color(0xFFECEFF1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getIconForStyle(MapStyle style) {
    switch (style) {
      case MapStyle.vibrant:
        return Icons.explore_outlined;
      case MapStyle.classic:
        return Icons.map_outlined;
      case MapStyle.dark:
        return Icons.dark_mode_outlined;
      case MapStyle.satellite:
        return Icons.satellite_alt_outlined;
      case MapStyle.minimal:
        return Icons.layers_clear_outlined;
    }
  }
}

enum MapStyle {
  vibrant('Vibrant', 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png'),
  classic('Classic', 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
  dark('Dark Sleek', 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png'),
  satellite('Satellite', 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'),
  minimal('Minimal Light', 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}@2x.png');

  const MapStyle(this.label, this.urlTemplate);
  final String label;
  final String urlTemplate;
}

class MapPin extends StatelessWidget {
  final Color color;
  final IconData icon;
  final bool isSelected;

  const MapPin({
    super.key,
    required this.color,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.25 : 1.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.elasticOut,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          CustomPaint(
            size: const Size(12, 6),
            painter: _TrianglePainter(color: color),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapLegend extends StatelessWidget {
  const _MapLegend();

  @override
  Widget build(BuildContext context) {
    final items = [
      (label: 'Hospital', color: ServiceType.hospital.color),
      (label: 'Police', color: ServiceType.police.color),
      (label: 'Fire', color: ServiceType.fire.color),
      (label: 'Ambulance', color: ServiceType.ambulance.color),
    ];

    return Semantics(
      label:
          'Map legend. Red hospital, blue police, orange fire, purple ambulance.',
      child: NeumorphicContainer(
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Wrap(
          spacing: 12,
          runSpacing: 8,
          children: items
              .map(
                (item) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _UserLocationIndicator extends StatefulWidget {
  final bool hasActualLocation;

  const _UserLocationIndicator({required this.hasActualLocation});

  @override
  State<_UserLocationIndicator> createState() => _UserLocationIndicatorState();
}

class _UserLocationIndicatorState extends State<_UserLocationIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasActualLocation) {
      return Center(
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
              )
            ],
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 12 + (14 * _controller.value),
              height: 12 + (14 * _controller.value),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.4 * (1 - _controller.value)),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
