import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/common/widgets/brands/brand_card.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/shimmer/brand_shimmer.dart';
import 'package:shop_app/features/shop/controllers/brand_controller.dart';
import 'package:shop_app/features/shop/screens/brands/product_brand.dart';
import 'package:shop_app/utils/constants/colors.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Tất cả danh mục',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Obx(() {
            if (brandController.isLoading.value) return CBrandsShimmer();

            if (brandController.allBrands.isEmpty) {
              return Center(
                child: Text(
                  "Không tìm thấy dữ liệu",
                  style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.black),
                ),
              );
            }
            return GridLayout(
              mainAxisExtent: 80,
              itemCount: brandController.allBrands.length,
              itemBuilder: (_, index) {
                final brand = brandController.allBrands[index];
                return BrandCard(
                  showBorder: true,
                  brand: brand,
                  onTap: () => Get.to(ProductBrandScreen(brand: brand)),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
