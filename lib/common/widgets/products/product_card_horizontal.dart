import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_image.dart';
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
                    child: RoundedImage(
                      width: 120,
                      imageUrl: product.thumbnail,
                      isNetworkImage: true,
                    ),
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
                        '$salePercentage%',
                        style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.black),
                      ),
                    ),
                  ),
                  // tim
                  Positioned(top: -10, right: -15, child: CFavouriteIcon(productId: product.id)),
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
                        ProductTitleText(text: product.title),
                        SizedBox(height: 6),
                        BrandTitleWithVerifiedIcon(title: product.brand!.name ?? ''),

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
                                    child: ProductPriceText(
                                      price: controller.getProductPrice(product),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Add to cart
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
      ),
    );
  }
}
