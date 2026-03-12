import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';

class CartCounterIcon extends StatelessWidget {
  const CartCounterIcon({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    // final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(CartController());
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28),
        ),
        Positioned(
          right: 2,
          top: 2,
          child: Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(100)),
            child: Center(
              child: Obx(
                () => Text(
                  controller.noOfCartItems.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.apply(color: Colors.white, fontSizeFactor: 0.8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
