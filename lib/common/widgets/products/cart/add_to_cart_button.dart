import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/features/shop/screens/product-details/product_detail.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/constants/sizes.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return InkWell(
      onTap: () {
        // Nếu sản phẩm có biến thể (variable) → chuyển sang màn chi tiết sản phẩm để chọn biến thể
        // Ngược lại → thêm trực tiếp sản phẩm vào giỏ hàng (với số lượng mặc định = 1)
        if (product.productType == ProductType.single.toString()) {
          final cartItem = cartController.convertToCartItem(product, 1);
          cartController.addOneToCart(
            cartItem,
          ); // Sử dụng addToCart để xử lý kiểm tra tồn kho, biến thể, v.v.
        } else {
          // Chuyển sang màn chi tiết sản phẩm để chọn biến thể
          Get.to(() => ProductDetail(product: product));
          // Hoặc hiển thị bottom sheet chọn variation
        }
      },
      child: Obx(() {
        final productQuantityInCart = cartController.getProductQuantityInCart(product.id);

        return Container(
          decoration: BoxDecoration(
            color: productQuantityInCart > 0 ? TColors.primary : Colors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(TSizes.cardRadiusMd),
              bottomRight: Radius.circular(TSizes.productImageRadius),
            ),
          ),
          child: SizedBox(
            width: TSizes.iconLg * 1.2,
            height: TSizes.iconLg * 1.2,
            child: Center(
              child: productQuantityInCart > 0
                  ? Text(
                      productQuantityInCart.toString(),
                      style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.white),
                    )
                  : const Icon(Icons.add_shopping_cart, color: TColors.white),
            ),
          ),
        );
      }),
    );
  }
}
