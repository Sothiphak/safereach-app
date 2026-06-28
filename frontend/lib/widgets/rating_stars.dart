import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size = 16});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor();
    final hasHalf = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final icon = index < fullStars
            ? Icons.star
            : index == fullStars && hasHalf
            ? Icons.star_half
            : Icons.star_border;
        return Icon(icon, color: Colors.amber, size: size);
      }),
    );
  }
}
