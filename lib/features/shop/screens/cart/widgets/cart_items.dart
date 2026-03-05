import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/products/cart/add_remove_button.dart';
import 'package:shop_app/common/widgets/products/cart/cart_item.dart';
import 'package:shop_app/common/widgets/text/product_price_text.dart';

class CartItems extends StatelessWidget {
  const CartItems({super.key, this.showAddRemoveButton = true});
  final bool showAddRemoveButton;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemCount: 2,
      itemBuilder: (_, index) => Column(
        children: [
          CartItem(),
          if (showAddRemoveButton)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [SizedBox(width: 66), ProductQuantityWithAddRemoveButton()]),
                ProductPriceText(price: 250.000, isLarge: false),
              ],
            ),
          Divider(),
        ],
      ),
    );
  }
}
