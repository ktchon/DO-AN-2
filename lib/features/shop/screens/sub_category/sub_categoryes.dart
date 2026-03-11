import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shop_app/common/images/banner_images.dart';
import 'package:shop_app/common/widgets/products/product_card_horizontal.dart';
import 'package:shop_app/common/widgets/shimmer/horizontal_product_shimmer.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/features/shop/controllers/category_controller.dart';
import 'package:shop_app/features/shop/models/category_model.dart';
import 'package:shop_app/features/shop/screens/all_products/all_products.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/helpers/cloud_helper_functions.dart';

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          category.name,
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Bannner khuyến mãi
              BannerImage(imageUrl: 'assets/banner/banner_3.png'),
              SizedBox(height: 28),
              // Thể loại
              FutureBuilder(
                future: controller.getSubCategories(category.id),
                builder: (context, snapshot) {
                  const loader = CHorizontalProductShimmer();
                  final widget = CloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot,
                    loader: loader,
                  );
                  if (widget != null) return widget;

                  final subCategories = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subCategories.length,
                    itemBuilder: (_, index) {
                      final subCategory = subCategories[index];

                      return FutureBuilder(
                        future: controller.getCategoryProducts(categoryId: subCategory.id),
                        builder: (context, snapshot) {
                          // Xử lý trạng thái: loading, empty, error
                          final widget = CloudHelperFunctions.checkMultiRecordState(
                            snapshot: snapshot,
                            loader: loader,
                          );
                          if (widget != null) return widget;

                          // Dữ liệu đã có
                          final products = snapshot.data!;

                          return Column(
                            children: [
                              SectionHeading(
                                showActionButton: true,
                                onPressed: () => Get.to(
                                  () => AllProductsScreen(
                                    title: subCategory.name,
                                    futureMethod: controller.getCategoryProducts(
                                      categoryId: subCategory.id,
                                      limit: -1,
                                    ),
                                  ),
                                ),
                                textTitle: subCategory.name,
                              ),

                              const SizedBox(height: 10),

                              // Danh sách sản phẩm ngang (horizontal)
                              SizedBox(
                                height: 120, // điều chỉnh theo chiều cao card của bạn
                                child: ListView.separated(
                                  itemCount: products.length,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) => const SizedBox(width: 20),
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return ProductCardHorizontal(product: product);
                                  },
                                ),
                              ),

                              const SizedBox(height: 32),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
