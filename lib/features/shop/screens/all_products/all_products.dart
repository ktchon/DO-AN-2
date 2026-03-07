import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shop_app/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shop_app/common/widgets/sortable/sortable_product.dart';
import 'package:shop_app/features/shop/controllers/all_products_controller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/constants/colors.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key, required this.title, this.query, this.futureMethod});

  final String title;
  final Query? query;
  final Future<List<ProductModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: FutureBuilder(
            future: futureMethod ?? controller.fetchProductsByQuery(query),
            builder: (context, snapshot) {
              // Kiểm tra trạng thái của snapshot trong FutureBuilder
              const loader = CVerticalProductShimmer();
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loader; // Đang tải → hiển thị shimmer loading
              }

              if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(child: Text('Không tìm thấy dữ liệu!'));
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Có lỗi xảy ra.'));
              }

              // Sản phẩm đã được tải thành công!
              final products = snapshot.data!;

              return SortableProducts(products: products);
            },
          ),
        ),
      ),
    );
  }
}
