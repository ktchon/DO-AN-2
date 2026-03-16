import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/features/shop/controllers/order_controller.dart';

class OrderCounterIcon extends StatelessWidget {
  const OrderCounterIcon({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    // final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(OrderController());
    return Obx(
      () => Stack(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(Iconsax.receipt_2_copy, color: Colors.white, size: 28),
          ),
          if (controller.noOfOrderItems.value > 0)
            Positioned(
              right: 8,
              top: 5,
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    '.',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.apply(color: Colors.white, fontSizeFactor: 0.8),
                  ),
                ),
              ),
            ),
          SizedBox(),
        ],
      ),
    );
  }
}
