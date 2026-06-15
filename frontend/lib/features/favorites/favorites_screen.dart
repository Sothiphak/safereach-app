import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../models/emergency_service.dart';
import '../../state/favorites_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/service_card.dart';
import '../../utils/translations.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();
    final favoritesState = context.watch<FavoritesState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'.tr(context)),
      ),
      body: FutureBuilder<List<EmergencyService>>(
        future: repository.getServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorState(
              title: 'Unable to load favorites'.tr(context),
              message: 'Please try again.'.tr(context),
              onRetry: () => setState(() {}),
            );
          }
          final services = snapshot.data ?? [];
          final favorites = services
              .where((service) => favoritesState.isFavorite(service.id))
              .toList();

          if (favorites.isEmpty) {
            return EmptyState(
              title: 'No favorites saved'.tr(context),
              message: 'Tap the heart icon to save emergency services.'.tr(context),
              icon: Icons.favorite_border,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final service = favorites[index];
              return Dismissible(
                key: ValueKey(service.id),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => favoritesState.removeFavorite(service.id),
                child: ServiceCard(
                  service: service,
                  onTap: () => context.go('/home/service/${service.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
