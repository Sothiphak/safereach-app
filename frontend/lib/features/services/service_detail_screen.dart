import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../models/emergency_service.dart';
import '../../models/review.dart';
import '../../state/favorites_state.dart';
import '../../utils/launcher.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/rating_stars.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service details'),
      ),
      body: FutureBuilder<EmergencyService?>(
        future: repository.getServiceById(widget.serviceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorState(
              title: 'Unable to load details',
              message: 'Please try again.',
              onRetry: () => setState(() {}),
            );
          }
          final service = snapshot.data;
          if (service == null) {
            return const EmptyState(
              title: 'Service not found',
              message: 'This emergency service is unavailable.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 220,
                child: PageView(
                  controller: _pageController,
                  children: List.generate(
                    3,
                    (index) {
                      final image = ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: CachedNetworkImage(
                          imageUrl: service.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => SvgPicture.asset(
                            'assets/images/placeholder.svg',
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => SvgPicture.asset(
                            'assets/images/placeholder.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                      if (index == 0) {
                        return Hero(tag: 'service-${service.id}', child: image);
                      }
                      return image;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(service.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  RatingStars(rating: service.rating, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${service.rating.toStringAsFixed(1)} (${service.reviewCount} reviews)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(service.description, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              _InfoRow(icon: Icons.location_on, label: service.address),
              _InfoRow(icon: Icons.schedule, label: service.hours),
              _InfoRow(icon: Icons.call, label: service.phone),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: service.services
                    .map((serviceName) => Chip(label: Text(serviceName)))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Consumer<FavoritesState>(
                builder: (context, favorites, child) {
                  final isFavorite = favorites.isFavorite(service.id);
                  return Row(
                    children: [
                      Expanded(
                        child: AppButton.primary(
                          label: 'Call now',
                          icon: Icons.call,
                          isFullWidth: true,
                          onPressed: () => launchPhone(context, service.phone),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
                        onPressed: () => favorites.toggleFavorite(service.id),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Text('Reviews', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              FutureBuilder<List<Review>>(
                future: repository.getReviewsForService(service.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final reviews = snapshot.data ?? [];
                  if (reviews.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('No reviews yet. Be the first to add one.'),
                    );
                  }
                  return Column(
                    children: reviews.map((review) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(review.author),
                                  Text(review.date, style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                              const SizedBox(height: 6),
                              RatingStars(rating: review.rating, size: 14),
                              const SizedBox(height: 6),
                              Text(review.comment),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
