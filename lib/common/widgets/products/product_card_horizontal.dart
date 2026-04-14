import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/widgets/products/cart/add_to_cart_button.dart';
import 'package:shop_app/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:shop_app/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:shop_app/common/widgets/text/product_price_text.dart';
import 'package:shop_app/common/widgets/text/product_title_text.dart';
import 'package:shop_app/features/shop/controllers/products/product_controller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/features/shop/screens/product-details/product_detail.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/constants/sizes.dart';

class ProductCardHorizontal extends StatelessWidget {
  const ProductCardHorizontal({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(ProductDetail(product: product)),
      child: Container(
        width: 310,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkGrey : TColors.lightContainer,
        ),
        child: Row(
          children: [
            // ── THUMBNAIL ───
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TSizes.productImageRadius),
                bottomLeft: Radius.circular(TSizes.productImageRadius),
              ),
              child: Stack(
                children: [
                  // Ảnh chính
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.network(
                      product.thumbnail,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: dark ? TColors.dark : TColors.white,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),

                  // Badge giảm giá
                  if (salePercentage != null && salePercentage.isNotEmpty && salePercentage != '0')
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$salePercentage%',
                          style: Theme.of(context).textTheme.labelSmall!.apply(color: Colors.black),
                        ),
                      ),
                    ),

                  // Nút yêu thích
                  Positioned(top: -8, right: -12, child: CFavouriteIcon(productId: product.id)),
                ],
              ),
            ),

            // ── NỘI DUNG ───
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductTitleText(text: product.title, maxLines: 2),
                        const SizedBox(height: 4),
                        BrandTitleWithVerifiedIcon(title: product.brand?.name ?? ''),
                        const SizedBox(height: 10),
                        if (product.productType == ProductType.single.toString() &&
                            product.salePrice > 0)
                          ProductPriceText(price: product.price, isLarge: false, lineThrough: true),
                        ProductPriceText(price: controller.getProductPrice(product)),
                      ],
                    ),
                  ),
                  // Nút + góc phải dưới
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 32,
                      width: 32,
                      child: AddToCartButton(product: product),
                    ),
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
