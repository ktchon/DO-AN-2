import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';
import 'package:shop_app/features/shop/screens/product_reviews/widgets/progress_indicator_and_rating.dart';

class OverallProductRating extends StatelessWidget {
  const OverallProductRating({super.key, required this.controller});

  final ReviewController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final avg = controller.averageRating;
      final percent = controller.ratingPercent;

      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(avg.toStringAsFixed(1), style: Theme.of(context).textTheme.displayLarge),
          ),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingProgressIndicator(text: '5', value: percent[5] ?? 0),
                RatingProgressIndicator(text: '4', value: percent[4] ?? 0),
                RatingProgressIndicator(text: '3', value: percent[3] ?? 0),
                RatingProgressIndicator(text: '2', value: percent[2] ?? 0),
                RatingProgressIndicator(text: '1', value: percent[1] ?? 0),
              ],
            ),
          ),
        ],
      );
    });
  }
}
