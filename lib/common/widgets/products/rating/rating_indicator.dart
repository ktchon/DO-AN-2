import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CRatingBarIndicator extends StatelessWidget {
  const CRatingBarIndicator({super.key, required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      itemCount: 5,
      itemSize: 13,
      rating: rating,
      itemBuilder: (_, __) => Icon(Icons.star, color: Colors.blueAccent,),
    );
  }
}
