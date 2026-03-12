import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_image.dart';
import 'package:shop_app/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:shop_app/common/widgets/text/product_title_text.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.cartItem});
  final CartItemModel cartItem;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Hình ảnh
        CircularImage(
          isNetworkImage: true,
          image: cartItem.image ?? '',
          borderRadius: 12,
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? Colors.black
              : const Color.fromARGB(255, 245, 244, 244),
        ),
        SizedBox(width: 10),
        // Tên sp, giá, thương hiệu, màu size
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              BrandTitleWithVerifiedIcon(title: cartItem.brandName ?? ''),
              Flexible(child: ProductTitleText(text: cartItem.title)),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      children: (cartItem.selectedVariation ?? {}).entries
                          .map(
                            (e) => TextSpan(
                              children: [
                                // Tên thuộc tính (key) - chữ nhỏ, thường
                                TextSpan(
                                  text: '${e.key}: ',
                                  style: TextStyle(fontSize: 10, color: Colors.black),
                                ),
                                // Giá trị thuộc tính (value) - chữ đậm/lớn hơn
                                TextSpan(
                                  text: '${e.value}  ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
