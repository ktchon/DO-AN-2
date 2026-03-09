import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/common/widgets/appbar/tabbar.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:shop_app/common/widgets/icons/cart_counter_icon.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/shimmer/brand_shimmer.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/common/widgets/brands/brand_card.dart';
import 'package:shop_app/features/shop/controllers/brand_controller.dart';
import 'package:shop_app/features/shop/controllers/category_controller.dart';
import 'package:shop_app/features/shop/screens/brands/all_brands.dart';
import 'package:shop_app/features/shop/screens/brands/product_brand.dart';
import 'package:shop_app/features/shop/screens/store/widgets/category_tab.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/constants/colors.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final category = CategoryController.instance.featuredCategories;
    final brandController = Get.put(BrandController());
    return DefaultTabController(
      length: category.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TColors.primary,
          automaticallyImplyLeading: false,
          title: Text('Cửa hàng', style: Theme.of(context).textTheme.headlineMedium),
          actions: [
            Padding(
              padding: EdgeInsetsGeometry.only(right: 10),
              child: CartCounterIcon(onPressed: () {}),
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                primary: false,
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: THelperFunctions.isDarkMode(context) ? Colors.black : Colors.white,
                expandedHeight: 440,

                flexibleSpace: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 12),
                      SearchContainer(text: 'Tìm kiếm danh mục...'),
                      SizedBox(height: 32),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SectionHeading(
                          onPressed: () => Get.to(() => AllBrandsScreen()),
                          textTitle: 'Thương hiệu',
                          textColor: THelperFunctions.isDarkMode(context)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Thương hiệu
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Obx(() {
                          if (brandController.isLoading.value) return CBrandsShimmer();

                          if (brandController.featuredBrands.isEmpty) {
                            return Center(
                              child: Text(
                                "Không tìm thấy dữ liệu",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.apply(color: Colors.black),
                              ),
                            );
                          }
                          return GridLayout(
                            mainAxisExtent: 80,
                            itemCount: brandController.featuredBrands.length,
                            itemBuilder: (_, index) {
                              final brand = brandController.featuredBrands[index];
                              return BrandCard(
                                showBorder: true,
                                brand: brand,
                                onTap: () => Get.to(ProductBrandScreen(brand: brand)),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                bottom: CTabBar(
                  tabs: category.map((category) => Tab(child: Text(category.name))).toList(),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: category.map((category) => CategoryTab(category: category)).toList(),
          ),
        ),
      ),
    );
  }
}
