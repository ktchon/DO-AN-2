import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/products/product_card_vartical.dart';
import 'package:shop_app/features/shop/controllers/products/recommendation_controller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';

class SimilarProductsSection extends StatelessWidget {
  const SimilarProductsSection({super.key, required this.products});
  final List<ProductModel> products;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = RecommendationController.instance.similarProducts;

      if (list.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sản phẩm tương tự",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridLayout(
            itemCount: list.length,
            itemBuilder: (_, index) => ProductCardVartical(product: list[index]),
          ),
        ],
      );
    });
  }
}
