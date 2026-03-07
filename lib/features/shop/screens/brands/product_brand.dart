import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/brands/brand_card.dart';
import 'package:shop_app/common/widgets/sortable/sortable_product.dart';
import 'package:shop_app/utils/constants/colors.dart';

class ProductBrandScreen extends StatelessWidget {
  const ProductBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Sản phẩm danh mục',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [BrandCard(showBorder: true), SizedBox(height: 28), SortableProducts(products: [],)],
          ),
        ),
      ),
    );
  }
}
