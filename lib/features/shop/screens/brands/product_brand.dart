import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/brands/brand_card.dart';
import 'package:shop_app/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shop_app/common/widgets/sortable/sortable_product.dart';
import 'package:shop_app/features/shop/controllers/brand_controller.dart';
import 'package:shop_app/features/shop/models/brand_model.dart';
import 'package:shop_app/utils/constants/colors.dart';

class ProductBrandScreen extends StatelessWidget {
  const ProductBrandScreen({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          brand.name,
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              BrandCard(showBorder: true, brand: brand),
              SizedBox(height: 28),
              FutureBuilder(
                future: brandController.getBrandProducts(brandId: brand.id),
                builder: (context, snapshot) {
                  if (brandController.isLoading.value) return CVerticalProductShimmer();

                  if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không tìm thấy dữ liệu!'));
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Đã xảy ra lỗi.'));
                  }

                  final brandProducts = snapshot.data!;

                  return SortableProducts(products: brandProducts);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
