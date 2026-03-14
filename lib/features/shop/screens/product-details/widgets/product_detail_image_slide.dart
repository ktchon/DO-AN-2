import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/appbar/appbar.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_image.dart';
import 'package:shop_app/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:shop_app/common/widgets/icons/cart_counter_icon.dart';
import 'package:shop_app/common/widgets/icons/circular_icon.dart';
import 'package:shop_app/common/widgets/icons/order_icon.dart';
import 'package:shop_app/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:shop_app/features/shop/controllers/products/image_controller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/features/shop/screens/cart/cart.dart';
import 'package:shop_app/features/shop/screens/order/order.dart';
import 'package:shop_app/utils/helpers/emulator_helper.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/constants/colors.dart';

class ProductImageSilder extends StatelessWidget {
  const ProductImageSilder({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(ImagesController());
    final images = controller.getAllProductImages(product);
    return CurvedEdgesWidget(
      child: Container(
        color: isDark ? TColors.white : TColors.darkGrey,
        child: Stack(
          children: [
            // PRODUCT IMAGE STAGE
            SizedBox(
              height: 400,
              child: Stack(
                children: [
                  // NỀN TRUNG TÍNH
                  Container(
                    width: double.infinity,
                    color: isDark ? Colors.black : Colors.grey.shade100,
                  ),

                  // KHU TRƯNG BÀY ẢNH
                  Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 65, left: 50, right: 50, bottom: 50),
                        child: Obx(() {
                          final image = controller.selectedProductImage.value;
                          final fixedImageUrl = fixEmulatorImageUrl(image);
                          return GestureDetector(
                            onTap: () => controller.showEnlargedImage(image),
                            child: CachedNetworkImage(
                              height: 250,
                              width: 200,
                              fit: BoxFit.contain,
                              imageUrl: fixedImageUrl,
                              progressIndicatorBuilder: (_, __, downloadProgress) =>
                                  CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    color: TColors.primary,
                                  ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  // GRADIENT BẢO VỆ UI
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              (isDark ? Colors.black : Colors.white).withOpacity(0.35),
                              Colors.transparent,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Image Slide
            Positioned(
              bottom: 30,
              right: 0,
              left: 20,
              child: SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (_, index) => Obx(() {
                    final imageSelected = controller.selectedProductImage.value == images[index];
                    final fixedImageUrl = fixEmulatorImageUrl(images[index]);
                    return RoundedImage(
                      isNetworkImage: true,
                      padding: EdgeInsets.all(0),
                      width: 60,
                      backgroundColor: isDark ? Colors.black : Colors.white,
                      border: Border.all(color: imageSelected ? TColors.primary : Colors.black),
                      imageUrl: fixedImageUrl,
                      onPressed: () => controller.selectedProductImage.value = images[index],
                    );
                  }),
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemCount: images.length,
                ),
              ),
            ),
            Appbar(
              color: isDark ? Colors.white : Colors.black,
              showBackArrow: true,
              title: Text(
                'Chi tiết sản phẩm',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium!.apply(color: isDark ? Colors.white : Colors.black),
              ),
              actions: [
                CartCounterIcon(colorCart: true ,onPressed: () => Get.to(() => CartItemScreen())),
                CFavouriteIcon(productId: product.id),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
