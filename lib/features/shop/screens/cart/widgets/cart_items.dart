import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/common/widgets/products/cart/add_remove_button.dart';
import 'package:shop_app/common/widgets/products/cart/cart_item.dart';
import 'package:shop_app/common/widgets/text/product_price_text.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';

class CartItems extends StatelessWidget {
  const CartItems({super.key, this.showAddRemoveButton = true});
  final bool showAddRemoveButton;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemCount: cartController.cartItems.length,
      itemBuilder: (_, index) => Obx(() {
        final item = cartController.cartItems[index];
        return Column(
          children: [
            CartItem(cartItem: item),
            if (showAddRemoveButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 66),
                      ProductQuantityWithAddRemoveButton(
                        quantity: item.quantity,
                        remove: () => cartController.removeOneFromCart(item),
                        add: () => cartController.addOneToCart(item),
                      ),
                    ],
                  ),
                  ProductPriceText(price: (item.price * item.quantity), isLarge: false),
                ],
              ),
            Divider(),
          ],
        );
      }),
    );
  }
}
