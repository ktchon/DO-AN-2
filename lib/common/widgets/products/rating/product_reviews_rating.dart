import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CRatingBar extends StatelessWidget {
  const CRatingBar({
    super.key,
    required this.rating,
    required this.onRatingUpdate,
    this.itemSize = 30,
  });

  final double rating;
  final double itemSize;
  final Function(double) onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: itemSize,
      itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: onRatingUpdate,
    );
  }
}