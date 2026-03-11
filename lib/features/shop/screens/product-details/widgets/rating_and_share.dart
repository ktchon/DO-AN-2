import 'package:flutter/material.dart';
import 'package:shop_app/data/products/share_product_repository.dart';
import 'package:shop_app/features/shop/controllers/products/share_product_controller.dart';
import 'package:shop_app/features/shop/models/share_product_model.dart';

class RatingAndShare extends StatelessWidget {
  const RatingAndShare({super.key, required this.product});

  final ShareProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ShareProductController(ShareProductRepository());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.star, color: Colors.yellow),
            SizedBox(width: 5),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '5.0 ', style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(text: '(199)'),
                ],
              ),
            ),
          ],
        ),
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
