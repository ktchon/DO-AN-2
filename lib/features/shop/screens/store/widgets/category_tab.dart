import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/products/product_card_vartical.dart';
import 'package:shop_app/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/features/shop/controllers/category_controller.dart';
import 'package:shop_app/features/shop/models/category_model.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/features/shop/screens/all_products/all_products.dart';
import 'package:shop_app/features/shop/screens/store/widgets/category_brands.dart';
import 'package:shop_app/utils/helpers/cloud_helper_functions.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              CategoryBrands(category: category),

              /// -- Products Section
              FutureBuilder<List<ProductModel>>(
                future: controller.getCategoryProducts(categoryId: category.id),
                builder: (context, snapshot) {
                  /// Helper Function: Xử lý trạng thái Loading, No Record, hoặc ERROR
                  final response = CloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot,
                    loader: const CVerticalProductShimmer(),
                  );

                  // Nếu đang loading / error / empty → trả về widget tương ứng ngay
                  if (response != null) return response;

                  /// Record Found! (Dữ liệu đã có)
                  final products = snapshot.data!;

                  return Column(
                    children: [
                      /// Phần heading + nút "Xem tất cả"
                      SectionHeading(
                        onPressed: () => Get.to(
                          () => AllProductsScreen(
                            title: category.name,
                            futureMethod: controller.getCategoryProducts(
                              categoryId: category.id,
                              limit: -1, // -1 nghĩa là lấy hết (không giới hạn)
                            ),
                          ),
                        ),
                        textTitle: 'Có thể bạn cũng thích',
                      ),

                      const SizedBox(height: 20),

                      /// Grid hiển thị danh sách sản phẩm
                      GridLayout(
                        itemCount: products.length,
                        itemBuilder: (_, index) => ProductCardVartical(product: products[index]),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
