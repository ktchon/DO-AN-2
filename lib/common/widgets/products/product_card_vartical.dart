import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/styles/shadows.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_image.dart';
import 'package:shop_app/common/widgets/icons/circular_icon.dart';
import 'package:shop_app/common/widgets/products/cart/add_to_cart_button.dart';
import 'package:shop_app/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:shop_app/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:shop_app/common/widgets/text/product_price_text.dart';
import 'package:shop_app/common/widgets/text/product_title_text.dart';
import 'package:shop_app/features/shop/controllers/products/product_controller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/features/shop/screens/product-details/product_detail.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/helpers/emulator_helper.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/constants/sizes.dart';

class ProductCardVartical extends StatelessWidget {
  const ProductCardVartical({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final fixedImageUrl = fixEmulatorImageUrl(product.thumbnail);
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () => Get.to(ProductDetail(product: product)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [ShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail - Yêu thích - giảm giá
            CircularContainer(
              radius: 16,
              height: 180,
              width: 180,
              padding: const EdgeInsets.all(10),
              backgroundColor: dark ? TColors.dark : TColors.white,
              child: Stack(
                children: [
                  // Thumbnail
                  Center(
                    child: RoundedImage(
                      imageUrl: fixedImageUrl,
                      applyImageRadius: true,
                      isNetworkImage: true,
                    ),
                  ),
                  // Giảm giá
                  if (salePercentage != null)
                    Positioned(
                      top: 12,
                      child: CircularContainer(
                        height: 28,
                        width: 50,
                        radius: 10,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        backgroundColor: Colors.yellowAccent.withOpacity(0.8),
                        child: Text(
                          '$salePercentage%',
                          style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.black),
                        ),
                      ),
                    ),
                  Positioned(top: 0, right: 0, child: CFavouriteIcon(productId: product.id)),
                ],
              ),
            ),
            SizedBox(height: 6),
            // Thông tin
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductTitleText(text: product.title),
                  SizedBox(height: 6),
                  BrandTitleWithVerifiedIcon(title: product.brand?.name ?? ''),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Giá
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.productType == ProductType.single.toString() &&
                          product.salePrice > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ProductPriceText(
                            price: product.price,
                            isLarge: false,
                            lineThrough: true,
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: ProductPriceText(price: controller.getProductPrice(product)),
                      ),
                    ],
                  ),
                ),
                // Add to cart
                AddToCartButton(product: product)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
