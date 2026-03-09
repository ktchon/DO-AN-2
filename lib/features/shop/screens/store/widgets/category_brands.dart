import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/brands/brand_showcase.dart';
import 'package:shop_app/common/widgets/shimmer/boxes_shimmer.dart';
import 'package:shop_app/common/widgets/shimmer/list_title_shimmer.dart';
import 'package:shop_app/features/shop/controllers/brand_controller.dart';
import 'package:shop_app/features/shop/models/category_model.dart';
import 'package:shop_app/utils/helpers/cloud_helper_functions.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return FutureBuilder(
      // Gọi hàm lấy danh sách thương hiệu theo ID danh mục
      future: controller.getBrandsForCategory(category.id),
      builder: (context, snapshot) {
        /// 1. Định nghĩa giao diện chờ (Loader) bằng cách kết hợp các Shimmer đã tạo
        const loader = Column(
          children: [
            CListTileShimmer(), // Hiệu ứng Shimmer cho tiêu đề dòng
            SizedBox(height: 20),
            CBoxesShimmer(), // Hiệu ứng Shimmer cho các ô vuông sản phẩm
            SizedBox(height: 20),
          ],
        );

        /// 2. Kiểm tra trạng thái dữ liệu (Đang tải, Lỗi, hoặc Trống)
        final widget = CloudHelperFunctions.checkMultiRecordState(
          snapshot: snapshot,
          loader: loader,
        );
        if (widget != null) return widget;

        /// 3. Khi đã có dữ liệu danh sách Thương hiệu (Record Found!)
        final brands = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: brands.length,
          itemBuilder: (_, index) {
            final brand = brands[index];

            // Với mỗi thương hiệu, tiếp tục gọi lấy sản phẩm của thương hiệu đó
            return FutureBuilder(
              future: controller.getBrandProducts(brandId: brand.id, limit: 3),
              builder: (context, snapshot) {
                /// Kiểm tra trạng thái dữ liệu sản phẩm của từng thương hiệu
                final widget = CloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot,
                  loader: loader,
                );
                if (widget != null) return widget;

                /// Khi đã có dữ liệu sản phẩm (Record Found!)
                final products = snapshot.data!;

                // Trả về Widget hiển thị Thương hiệu kèm danh sách ảnh sản phẩm
                return BrandShowcase(
                  brand: brand,
                  images: products.map((e) => e.thumbnail).toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}
