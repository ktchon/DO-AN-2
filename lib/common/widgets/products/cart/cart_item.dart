import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_image.dart';
import 'package:shop_app/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:shop_app/common/widgets/text/product_title_text.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Hình ảnh
        CircularImage(
          image: 'assets/products/product-2.png',
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
              BrandTitleWithVerifiedIcon(title: 'Nike'),
              Flexible(child: ProductTitleText(text: 'Giày Nike cao cấp mới nhất 2026')),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Màu sắc: ',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Xanh',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Size: ',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        TextSpan(
                          text: 'M',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
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
