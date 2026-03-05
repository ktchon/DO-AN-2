import 'package:flutter/material.dart';
import 'package:shop_app/features/shop/screens/product_reviews/widgets/progress_indicator_and_rating.dart';

class OverallProductRating extends StatelessWidget {
  const OverallProductRating({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text('5.0', style: Theme.of(context).textTheme.displayLarge)),
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            RatingProgressIndicator(text: '5', value: 0.8),
            RatingProgressIndicator(text: '4', value: 0.5),
            RatingProgressIndicator(text: '3', value: 0.2),
            RatingProgressIndicator(text: '2', value: 0.3),
            RatingProgressIndicator(text: '1', value: 0.1),
            ]),
        ),
      ],
    );
  }
}
