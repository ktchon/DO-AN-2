import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/products/product_card_vartical.dart';
import 'package:shop_app/features/shop/controllers/all_products_controller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';

class SortableProducts extends StatelessWidget {
  const SortableProducts({super.key, required this.products});
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AllProductsController>();
    controller.assignProducts(products);
    return Column(
      children: [
        DropdownButtonFormField(
          decoration: InputDecoration(prefixIcon: Icon(Icons.filter_list)),
          value: controller.selectedSortOption.value,
          items: [
            'Name',
            'Giá cao',
            'Giá thấp',
            'Hàng mới',
            'Giảm giá',
          ].map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
          onChanged: (value) {
            controller.sortProducts(value!);
          },
        ),
        SizedBox(height: 28),
        Obx(
          () => GridLayout(
            itemCount: controller.products.length,
            itemBuilder: (_, index) => ProductCardVartical(product: controller.products[index]),
          ),
        ),
      ],
    );
  }
}
