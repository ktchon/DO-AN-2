import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/widgets/loaders/animation_loader.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
import 'package:shop_app/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:shop_app/features/shop/screens/checkout/checkout.dart';
import 'package:shop_app/navigation_menu.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/formatters/formatter.dart';

class CartItemScreen extends StatelessWidget {
  const CartItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, // màu icon back
          ),
          title: Text(
            'Giỏ hàng',
            style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
          ),
          backgroundColor: TColors.primary,
        ),
        body: Obx(() {
          // Widget hiển thị khi không tìm thấy sản phẩm (giỏ hàng trống)
          final emptyWidget = CAnimationLoaderWidget(
            text: 'Giỏ hàng đang TRỐNG.',
            animation: 'assets/logo/shopping-cart.json',
            showAction: true,
            actionText: 'Đi mua sắm ngay nào!',
            onActionPressed: () => Get.off(() => const NavigationMenu()),
          );

          if (cartController.cartItems.isEmpty) {
            return emptyWidget;
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),

                /// --- Danh sách sản phẩm trong giỏ hàng ---
                child: CartItems(),
              ),
            );
          }
        }),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(20),
          child: cartController.cartItems.isEmpty
              ? null
              : ElevatedButton(
                  onPressed: () => Get.to(() => CheckoutScreen()),
                  child: Obx(() {
                    final formattedTotal = TFormatter.formatVND(
                      cartController.totalCartPrice.value,
                    );
                    return Text('Thanh Toán $formattedTotal');
                  }),
                ),
        ),
      ),
    );
  }
}
