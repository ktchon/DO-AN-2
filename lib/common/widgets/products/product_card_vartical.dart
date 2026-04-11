import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/styles/shadows.dart';
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
      onTap: () => Get.to(() => ProductDetail(product: product)),
      child: Container(
        width: 180, 
        decoration: BoxDecoration(
          boxShadow: [ShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Ảnh chính 
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(TSizes.productImageRadius),
                    topRight: Radius.circular(TSizes.productImageRadius),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 180, 
                    child: Image.network(
                      fixedImageUrl,
                      fit: BoxFit.cover, 
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.error_outline, size: 40)),
                    ),
                  ),
                ),

                // Giảm giá (nếu có)
                if (salePercentage != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$salePercentage%',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.apply(color: Colors.black, fontWeightDelta: 2),
                      ),
                    ),
                  ),

                // Icon trái tim
                Positioned(top: 8, right: 8, child: CFavouriteIcon(productId: product.id)),
              ],
            ),

            // ==================== PHẦN THÔNG TIN ====================
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductTitleText(text: product.title),
                  const SizedBox(height: 6),
                  BrandTitleWithVerifiedIcon(title: product.brand?.name ?? ''),
                  const SizedBox(height: 8),

                  // Giá + Add to cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.productType == ProductType.single.toString() &&
                                product.salePrice > 0)
                              ProductPriceText(
                                price: product.price,
                                isLarge: false,
                                lineThrough: true,
                              ),
                            ProductPriceText(
                              price: controller.getProductPrice(product),
                              isLarge: true,
                            ),
                          ],
                        ),
                      ),
                      AddToCartButton(product: product),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
