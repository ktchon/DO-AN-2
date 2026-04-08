import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/data/products/share_product_repository.dart';
import 'package:shop_app/features/shop/controllers/products/share_product_controller.dart';
import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';
import 'package:shop_app/features/shop/models/share_product_model.dart';

class RatingAndShare extends StatelessWidget {
  const RatingAndShare({super.key, required this.product});

  final ShareProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ShareProductController(ShareProductRepository());
    final controllerReview = ReviewController.instance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() {
          final avg = controllerReview.averageRating;
          final total = controllerReview.totalReviews;
          return Row(
            children: [
              Icon(Icons.star, color: Colors.yellow),
              SizedBox(width: 5),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "$avg", style: Theme.of(context).textTheme.bodyLarge),
                    TextSpan(text: '($total)'),
                  ],
                ),
              ),
            ],
          );
        }),
        IconButton(
          onPressed: () async {
            await controller.share(product);
          },
          icon: Icon(Icons.share),
        ),
      ],
    );
  }
}
