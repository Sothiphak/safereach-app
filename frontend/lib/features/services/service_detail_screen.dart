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

  Future<void> _openWriteReviewModal(BuildContext context, MockRepository repository) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return _WriteReviewBottomSheet(
          serviceId: widget.serviceId,
          repository: repository,
          onSubmitted: () {
            setState(() {}); // Trigger refresh on details screen
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
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
              // Swipeable Image Gallery
              SizedBox(
                height: 240,
                child: Stack(
                  children: [
                    PageView(
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
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            final page = _pageController.hasClients ? _pageController.page ?? 0 : 0;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (dotIndex) {
                                final diff = (page - dotIndex).abs();
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  height: 8,
                                  width: diff < 0.5 ? 24 : 8,
                                  decoration: BoxDecoration(
                                    color: diff < 0.5 ? Colors.white : Colors.white54,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Title and Core Details
              Text(
                service.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  RatingStars(rating: service.rating, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${service.rating.toStringAsFixed(1)} (${service.reviewCount} reviews)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Service',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Info rows
              _InfoRow(icon: Icons.location_on, label: service.address),
              _InfoRow(icon: Icons.schedule, label: service.hours),
              _InfoRow(icon: Icons.call, label: service.phone),
              const SizedBox(height: 16),

              // Service Tags / Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: service.services
                    .map((serviceName) => Chip(
                          label: Text(
                            serviceName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                          side: BorderSide.none,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // CTA buttons
              Consumer<FavoritesState>(
                builder: (context, favorites, child) {
                  final isFavorite = favorites.isFavorite(service.id);
                  return Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: AppButton.primary(
                            label: 'CALL NOW',
                            icon: Icons.call,
                            isFullWidth: true,
                            onPressed: () => launchPhone(context, service.phone),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 54,
                        width: 54,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isFavorite ? const Color(0xFFD32F2F) : Colors.transparent,
                          ),
                        ),
                        child: IconButton(
                          tooltip: isFavorite ? 'Remove Favorite' : 'Save Favorite',
                          onPressed: () {
                            favorites.toggleFavorite(service.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite ? 'Removed from favorites' : 'Saved to favorites',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: const Color(0xFFD32F2F),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // Reviews Header & Star Rating Summary + Distribution Bars
              FutureBuilder<List<Review>>(
                future: repository.getReviewsForService(service.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final reviews = snapshot.data ?? [];

                  // Calculate rating distribution
                  final totalReviews = reviews.length;
                  double averageRating = service.rating;
                  int r5 = 0, r4 = 0, r3 = 0, r2 = 0, r1 = 0;

                  if (totalReviews > 0) {
                    double sum = 0;
                    for (var r in reviews) {
                      sum += r.rating;
                      final rounded = r.rating.round();
                      if (rounded >= 5) {
                        r5++;
                      } else if (rounded == 4) {
                        r4++;
                      } else if (rounded == 3) {
                        r3++;
                      } else if (rounded == 2) {
                        r2++;
                      } else {
                        r1++;
                      }
                    }
                    averageRating = sum / totalReviews;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews & Ratings',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextButton.icon(
                            onPressed: () => _openWriteReviewModal(context, repository),
                            icon: const Icon(Icons.rate_review_outlined, size: 18),
                            label: const Text(
                              'Write a review',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Ratings Summary & Distribution Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Left: Average Stars Column
                              Column(
                                children: [
                                  Text(
                                    averageRating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFFD32F2F),
                                      letterSpacing: -1.5,
                                    ),
                                  ),
                                  RatingStars(rating: averageRating, size: 14),
                                  const SizedBox(height: 6),
                                  Text(
                                    '$totalReviews review${totalReviews == 1 ? "" : "s"}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 24),
                              // Right: Distribution Bars
                              Expanded(
                                child: Column(
                                  children: [
                                    _DistributionRow(
                                      star: 5,
                                      percentage: totalReviews == 0 ? 0.7 : r5 / totalReviews,
                                    ),
                                    _DistributionRow(
                                      star: 4,
                                      percentage: totalReviews == 0 ? 0.2 : r4 / totalReviews,
                                    ),
                                    _DistributionRow(
                                      star: 3,
                                      percentage: totalReviews == 0 ? 0.1 : r3 / totalReviews,
                                    ),
                                    _DistributionRow(
                                      star: 2,
                                      percentage: totalReviews == 0 ? 0.0 : r2 / totalReviews,
                                    ),
                                    _DistributionRow(
                                      star: 1,
                                      percentage: totalReviews == 0 ? 0.0 : r1 / totalReviews,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Individual Review Cards
                      if (reviews.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No reviews posted yet. Be the first to share your experience!',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              color: isDark ? const Color(0xFF232323) : const Color(0xFFFAFAFA),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          review.author,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          review.date,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Colors.grey[500],
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    RatingStars(rating: review.rating, size: 14),
                                    const SizedBox(height: 8),
                                    Text(
                                      review.comment,
                                      style: const TextStyle(fontSize: 13, height: 1.3),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFFD32F2F)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionRow extends StatelessWidget {
  const _DistributionRow({required this.star, required this.percentage});

  final int star;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            '$star ★',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 28,
          child: Text(
            '${(percentage * 100).round()}%',
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _WriteReviewBottomSheet extends StatefulWidget {
  const _WriteReviewBottomSheet({
    required this.serviceId,
    required this.repository,
    required this.onSubmitted,
  });

  final String serviceId;
  final MockRepository repository;
  final VoidCallback onSubmitted;

  @override
  State<_WriteReviewBottomSheet> createState() => _WriteReviewBottomSheetState();
}

class _WriteReviewBottomSheetState extends State<_WriteReviewBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _authorController = TextEditingController();
  final _commentController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _authorController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, bottomPadding + 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Submit Emergency Review',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 18),

            // Star selector
            const Text(
              'Rate your experience',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final ratingVal = index + 1;
                return IconButton(
                  onPressed: () => setState(() => _rating = ratingVal),
                  icon: Icon(
                    ratingVal <= _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Author Name Field
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please input your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Comment Field
            TextFormField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Describe your emergency experience',
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please add a comment description';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final name = _authorController.text.trim();
                    final comment = _commentController.text.trim();

                    final review = Review(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      serviceId: widget.serviceId,
                      author: name,
                      rating: _rating.toDouble(),
                      date: DateTime.now().toString().split(' ')[0], // YYYY-MM-DD
                      comment: comment,
                    );

                    await widget.repository.addReview(review);
                    widget.onSubmitted();

                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Review submitted successfully! Thank you.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text(
                  'SUBMIT REVIEW',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
