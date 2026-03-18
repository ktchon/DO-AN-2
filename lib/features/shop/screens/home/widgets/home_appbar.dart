import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/widgets/appbar/appbar.dart';
import 'package:shop_app/common/widgets/icons/cart_counter_icon.dart';
import 'package:shop_app/common/widgets/icons/order_icon.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';
import 'package:shop_app/features/personalization/controllers/user/user_controller.dart';
import 'package:shop_app/features/shop/screens/cart/cart.dart';
import 'package:shop_app/features/shop/screens/order/order.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Appbar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chào bạn đến với cửa hàng",
            style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.black),
          ),
          Obx(() {
            if (controller.profileLoading.value) {
              return CShimmerEffect(width: 80, height: 15);
            } else {
              return Text(
                controller.user.value.fullName,
                style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.white),
              );
            }
          }),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(top: 6),
          child: OrderCounterIcon(onPressed: () => Get.to(OrderScreen()))),
        CartCounterIcon(onPressed: () => Get.to(() => CartItemScreen())),
      ],
    );
  }
}
