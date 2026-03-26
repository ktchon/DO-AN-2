import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CRatingBarIndicator extends StatelessWidget {
  const CRatingBarIndicator({super.key, required this.rating, this.itemSize = 13});
  final double rating;
  final double itemSize;
  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      itemCount: 5,
      itemSize: itemSize,
      rating: rating,
      itemBuilder: (_, __) => Icon(Icons.star, color: Colors.blueAccent),
    );
  }
}
