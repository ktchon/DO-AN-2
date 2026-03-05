import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/brands/brand_showcase.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/products/product_card_vartical.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/features/shop/models/category_model.dart';
import 'package:shop_app/features/shop/models/product_model.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              BrandShowcase(
                images: [
                  'assets/products/product-1.png',
                  'assets/products/product-2.png',
                  'assets/products/product-1.png',
                ],
              ),
              BrandShowcase(
                images: [
                  'assets/products/product-1.png',
                  'assets/products/product-2.png',
                  'assets/products/product-1.png',
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SectionHeading(
                  textTitle: 'Sản phẩm',
                  showActionButton: true,
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: GridLayout(
                  itemCount: 6,
                  itemBuilder: (_, index) => ProductCardVartical(product: ProductModel.empty()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
