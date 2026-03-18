import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/products/product_card_vartical.dart';
import 'package:shop_app/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/features/shop/controllers/products/product_controller.dart';
import 'package:shop_app/features/shop/screens/all_products/all_products.dart';
import 'package:shop_app/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:shop_app/features/shop/screens/home/widgets/home_categories.dart';
import 'package:shop_app/features/shop/screens/home/widgets/promo_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  // Appbar
                  HomeAppbar(),
                  SizedBox(height: 16),
                  // Thanh tìm kiếm
                  SearchContainer(text: 'Tìm kiếm sản phẩm...'),
                  SizedBox(height: 16),
                  // Danh mục
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        //heading
                        SectionHeading(
                          textTitle: 'Danh mục',
                          style: true,
                          textColor: Colors.white,
                          showActionButton: false,
                        ),
                        SizedBox(height: 2),
                        // Danh mục
                        HomeCategories(),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12, right: 28, left: 28, bottom: 28),
              child: Column(
                children: [
                  // banner
                  PromoSlider(),
                  SizedBox(height: 20),
                  SectionHeading(
                    textTitle: 'Sản phẩm nổi bật',
                    showActionButton: true,
                    onPressed: () => Get.to(
                      () => AllProductsScreen(
                        title: 'Tất cả sản phẩm',
                        futureMethod: controller.getAllFeaturedProducts(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // ProductsCard
                  Obx(() {
                    if (controller.isLoading.value) return CVerticalProductShimmer();

                    if (controller.featuredProducts.isEmpty) {
                      return Center(
                        child: Text(
                          'Không tìm thấy dữ liệu',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                    return GridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_, index) =>
                          ProductCardVartical(product: controller.featuredProducts[index]),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
