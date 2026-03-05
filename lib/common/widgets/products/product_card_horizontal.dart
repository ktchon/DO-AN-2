import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_image.dart';
import 'package:shop_app/common/widgets/icons/circular_icon.dart';
import 'package:shop_app/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:shop_app/common/widgets/text/product_price_text.dart';
import 'package:shop_app/common/widgets/text/product_title_text.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/constants/sizes.dart';

class ProductCardHorizontal extends StatelessWidget {
  const ProductCardHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      width: 310,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.productImageRadius),
        color: dark ? TColors.darkGrey : TColors.lightContainer,
      ),
      child: Row(
        children: [
          // thumnail
          RoundedContainer(
            height: 120,
            backgroundColor: dark ? TColors.dark : TColors.white,
            child: Stack(
              children: [
                // ảnh chính
                SizedBox(
                  width: 120,
                  height: 120,
                  child: RoundedImage(width: 120, imageUrl: 'assets/products/product-2.png'),
                ),
                // Giảm giá
                Positioned(
                  top: 0,
                  left: 0,

                  child: RoundedContainer(
                    height: 28,
                    width: 50,
                    radius: 10,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    backgroundColor: Colors.yellowAccent.withOpacity(0.8),
                    child: Text(
                      '25%',
                      style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.black),
                    ),
                  ),
                ),
                // tim
                Positioned(
                  top: -10,
                  right: -15,
                  child: CircularIcon(
                    icon: Iconsax.heart,
                    size: 20,
                    color: Colors.red,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProductTitleText(text: 'Giày NiKe thể thao nam cao cấp'),
                      SizedBox(height: 6),
                      BrandTitleWithVerifiedIcon(title: 'Nike'),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Giá
                          Flexible(child: ProductPriceText(price: 500.000)),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: SizedBox(
                              height: 32,
                              width: 32,
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
