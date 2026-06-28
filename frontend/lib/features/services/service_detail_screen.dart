import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/emergency_repository.dart';
import '../../models/emergency_service.dart';
import '../../models/review.dart';
import '../../models/service_type.dart';
import '../../state/favorites_state.dart';
import '../../utils/launcher.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/neumorphic_container.dart';
import '../../widgets/neumorphic_button.dart';
import '../../utils/translations.dart';

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

  Future<void> _openWriteReviewModal(
    BuildContext context,
    EmergencyRepository repository,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return _WriteReviewBottomSheet(
          serviceId: widget.serviceId,
          repository: repository,
          onSubmitted: () {
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<EmergencyRepository>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Service Details'.tr(context))),
      body: FutureBuilder<EmergencyService?>(
        future: repository.getServiceById(widget.serviceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorState(
              title: 'Unable to load details'.tr(context),
              message: 'Please try again.'.tr(context),
              onRetry: () => setState(() {}),
            );
          }
          final service = snapshot.data;
          if (service == null) {
            return EmptyState(
              title: 'Service not found'.tr(context),
              message: 'This emergency service is unavailable.'.tr(context),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 240,
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      children: List.generate(3, (index) {
                        final image = ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: CachedNetworkImage(
                            imageUrl: service.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => SvgPicture.asset(
                              'assets/images/placeholder.svg',
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) =>
                                SvgPicture.asset(
                                  'assets/images/placeholder.svg',
                                  fit: BoxFit.cover,
                                ),
                          ),
                        );
                        if (index == 0) {
                          return Hero(
                            tag: 'service-${service.id}',
                            child: image,
                          );
                        }
                        return image;
                      }),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            final page = _pageController.hasClients
                                ? _pageController.page ?? 0
                                : 0;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (dotIndex) {
                                final diff = (page - dotIndex).abs();
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  height: 8,
                                  width: diff < 0.5 ? 24 : 8,
                                  decoration: BoxDecoration(
                                    color: diff < 0.5
                                        ? Colors.white
                                        : Colors.white54,
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

              Text(
                service.name.tr(context),
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
                    '${service.rating.toStringAsFixed(1)} (${service.reviewCount} ${(service.reviewCount == 1 ? "review" : "reviews").tr(context)})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              NeumorphicContainer(
                borderRadius: 20,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Service'.tr(context),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.description.tr(context),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _InfoRow(
                icon: Icons.location_on,
                label: service.address.tr(context),
              ),
              _InfoRow(icon: Icons.schedule, label: service.hours),
              _InfoRow(icon: Icons.call, label: service.phone),
              const SizedBox(height: 16),

              NeumorphicContainer(
                borderRadius: 20,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency capabilities',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _capabilityTagsFor(service)
                          .map(
                            (tag) => _CapabilityTag(
                              icon: tag.icon,
                              label: tag.label,
                              color: tag.color,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: service.services
                    .map(
                      (serviceName) => NeumorphicContainer(
                        borderRadius: 12,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          serviceName.tr(context),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),

              Consumer<FavoritesState>(
                builder: (context, favorites, child) {
                  final isFavorite = favorites.isFavorite(service.id);
                  return Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: AppButton.primary(
                            label: 'CALL NOW'.tr(context),
                            icon: Icons.call,
                            isFullWidth: true,
                            onPressed: () =>
                                launchPhone(context, service.phone),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      NeumorphicButton(
                        borderRadius: 16,
                        onTap: () {
                          favorites.toggleFavorite(service.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                (isFavorite
                                        ? 'Removed from favorites'
                                        : 'Saved to favorites')
                                    .tr(context),
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        border: isFavorite
                            ? Border.all(
                                color: const Color(0xFFD32F2F),
                                width: 1.5,
                              )
                            : null,
                        child: SizedBox(
                          height: 54,
                          width: 54,
                          child: Icon(
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

              FutureBuilder<List<Review>>(
                future: repository.getReviewsForService(service.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final reviews = snapshot.data ?? [];

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
                            'Reviews & Ratings'.tr(context),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                _openWriteReviewModal(context, repository),
                            icon: const Icon(
                              Icons.rate_review_outlined,
                              size: 18,
                            ),
                            label: Text(
                              'Write a review'.tr(context),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      NeumorphicContainer(
                        borderRadius: 20,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
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
                                  '$totalReviews ${(totalReviews == 1 ? "review" : "reviews").tr(context)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                children: [
                                  _DistributionRow(
                                    star: 5,
                                    percentage: totalReviews == 0
                                        ? 0.7
                                        : r5 / totalReviews,
                                  ),
                                  _DistributionRow(
                                    star: 4,
                                    percentage: totalReviews == 0
                                        ? 0.2
                                        : r4 / totalReviews,
                                  ),
                                  _DistributionRow(
                                    star: 3,
                                    percentage: totalReviews == 0
                                        ? 0.1
                                        : r3 / totalReviews,
                                  ),
                                  _DistributionRow(
                                    star: 2,
                                    percentage: totalReviews == 0
                                        ? 0.0
                                        : r2 / totalReviews,
                                  ),
                                  _DistributionRow(
                                    star: 1,
                                    percentage: totalReviews == 0
                                        ? 0.0
                                        : r1 / totalReviews,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (reviews.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No reviews posted yet. Be the first to share your experience!'
                                  .tr(context),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
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
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: NeumorphicContainer(
                                borderRadius: 16,
                                isPressed: true,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.grey[500],
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    RatingStars(
                                      rating: review.rating,
                                      size: 14,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      review.comment,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        height: 1.3,
                                      ),
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

List<_CapabilityTagData> _capabilityTagsFor(EmergencyService service) {
  final tags = <_CapabilityTagData>[];
  final services = service.services.map((item) => item.toLowerCase()).toSet();
  final isAlwaysOpen = service.openNow || service.hours.toLowerCase() == '24/7';

  void add({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    if (tags.any((tag) => tag.label == label)) {
      return;
    }
    tags.add(_CapabilityTagData(icon: icon, label: label, color: color));
  }

  if (isAlwaysOpen) {
    add(
      icon: Icons.schedule,
      label: '24/7 open',
      color: const Color(0xFF0F766E),
    );
  }

  switch (service.type) {
    case ServiceType.hospital:
      add(
        icon: Icons.local_hospital,
        label: 'Ambulance available',
        color: service.type.color,
      );
      if (services.contains('icu')) {
        add(
          icon: Icons.monitor_heart_outlined,
          label: 'ICU',
          color: const Color(0xFFDC2626),
        );
      }
      if (services.contains('trauma')) {
        add(
          icon: Icons.emergency_outlined,
          label: 'Trauma care',
          color: const Color(0xFFB91C1C),
        );
      }
      if (services.contains('surgery')) {
        add(
          icon: Icons.medical_services_outlined,
          label: 'Surgery team',
          color: const Color(0xFFBE123C),
        );
      }
      break;
    case ServiceType.police:
      add(
        icon: Icons.local_police,
        label: 'Police response',
        color: service.type.color,
      );
      add(
        icon: Icons.directions_car_outlined,
        label: 'Patrol unit',
        color: service.type.color,
      );
      add(
        icon: Icons.report_outlined,
        label: 'Incident reporting',
        color: service.type.color,
      );
      break;
    case ServiceType.fire:
      add(
        icon: Icons.local_shipping_outlined,
        label: 'Fire rescue truck',
        color: service.type.color,
      );
      add(
        icon: Icons.health_and_safety_outlined,
        label: 'Rescue team',
        color: service.type.color,
      );
      add(
        icon: Icons.local_fire_department_outlined,
        label: 'Fire response',
        color: service.type.color,
      );
      break;
    case ServiceType.ambulance:
      add(
        icon: Icons.airport_shuttle,
        label: 'Ambulance available',
        color: service.type.color,
      );
      add(
        icon: Icons.medical_information_outlined,
        label: 'Paramedics',
        color: service.type.color,
      );
      add(
        icon: Icons.route_outlined,
        label: 'Emergency transport',
        color: service.type.color,
      );
      break;
    case ServiceType.women:
      add(
        icon: Icons.support_agent,
        label: 'Women support hotline',
        color: service.type.color,
      );
      add(
        icon: Icons.volunteer_activism_outlined,
        label: 'Counseling',
        color: service.type.color,
      );
      add(
        icon: Icons.home_work_outlined,
        label: 'Shelter referral',
        color: service.type.color,
      );
      break;
    case ServiceType.disaster:
      add(
        icon: Icons.crisis_alert,
        label: 'Disaster relief',
        color: service.type.color,
      );
      add(
        icon: Icons.inventory_2_outlined,
        label: 'Relief supplies',
        color: service.type.color,
      );
      add(
        icon: Icons.groups_outlined,
        label: 'Evacuation support',
        color: service.type.color,
      );
      break;
  }

  add(
    icon: Icons.phone_in_talk_outlined,
    label: 'Direct hotline',
    color: service.type.color,
  );

  return tags;
}

class _CapabilityTagData {
  const _CapabilityTagData({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;
}

class _CapabilityTag extends StatelessWidget {
  const _CapabilityTag({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: 'Emergency capability $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.20 : 0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
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
  final EmergencyRepository repository;
  final VoidCallback onSubmitted;

  @override
  State<_WriteReviewBottomSheet> createState() =>
      _WriteReviewBottomSheetState();
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
                'Submit Emergency Review'.tr(context),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 18),

            Text(
              'Rate your experience'.tr(context),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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

            NeumorphicContainer(
              borderRadius: 16,
              isPressed: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Your Name'.tr(context),
                  prefixIcon: const Icon(Icons.person_outline),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: false,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please input your name'.tr(context);
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicContainer(
              borderRadius: 16,
              isPressed: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextFormField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Describe your emergency experience'.tr(context),
                  prefixIcon: const Icon(Icons.notes),
                  alignLabelWithHint: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: false,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please add a comment description'.tr(context);
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),

            AppButton.primary(
              label: 'SUBMIT REVIEW'.tr(context),
              isFullWidth: true,
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
                    SnackBar(
                      content: Text(
                        'Review submitted successfully! Thank you.'.tr(context),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
