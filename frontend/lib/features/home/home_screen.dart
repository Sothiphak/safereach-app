import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../models/emergency_service.dart';
import '../../models/service_type.dart';
import '../../state/favorites_state.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SafeReach', style: Theme.of(context).textTheme.titleLarge),
            Text('Emergency support', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            onPressed: () => context.go('/home/favorites'),
            icon: const Icon(Icons.favorite_border),
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
          final filtered = services
              .where((service) => service.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();
          final featured = filtered.take(6).toList();
          final favoritesState = context.watch<FavoritesState>();
          final favoriteServices = services
              .where((service) => favoritesState.isFavorite(service.id))
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _LocationRow(
                location: 'Phnom Penh, BKK1',
                onSettings: () => context.go('/settings'),
              ),
              const SizedBox(height: 16),
              _HeroBanner(
                onSosTap: () => context.go('/home/services/ambulance'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Search hospitals, police posts, fire stations',
                  prefixIcon: const Icon(Icons.search),
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
              const SizedBox(height: 20),
              SectionHeader(
                title: 'Quick actions',
                actionLabel: 'See all',
                onAction: () => context.go('/home/services/hospital'),
              ),
              const SizedBox(height: 12),
              _CategoryGrid(onTap: (type) => context.go('/home/services/${type.name}')),
              const SizedBox(height: 20),
              const _PromotionStrip(),
              const SizedBox(height: 20),
              SectionHeader(title: 'Featured nearby'),
              const SizedBox(height: 12),
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
              SectionHeader(
                title: 'Your favorites',
                actionLabel: 'Manage',
                onAction: () => context.go('/home/favorites'),
              ),
              const SizedBox(height: 12),
              if (favoriteServices.isEmpty)
                const EmptyState(
                  title: 'No favorites yet',
                  message: 'Save emergency services for quick access.',
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
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.location, required this.onSettings});

  final String location;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 6),
              Text(location, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Settings',
          onPressed: onSettings,
          icon: const Icon(Icons.tune),
        ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onSosTap});

  final VoidCallback onSosTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency SOS',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the SOS button to reach help quickly.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SosButton(onPressed: onSosTap),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.onTap});

  final ValueChanged<ServiceType> onTap;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 720;
    return GridView.count(
      crossAxisCount: isTablet ? 4 : 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: ServiceType.values.map((type) {
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onTap(type),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: type.color.withValues(alpha: 0.12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(type.icon, color: type.color, size: 32),
                const SizedBox(height: 8),
                Text(type.label, textAlign: TextAlign.center),
              ],
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
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
      ),
      child: Row(
        children: [
          Icon(Icons.campaign, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Stay prepared: update your personal contacts and first-aid info.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
