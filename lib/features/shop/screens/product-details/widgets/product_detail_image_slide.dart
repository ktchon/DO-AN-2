import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/features/shop/controllers/products/image_controller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/helpers/emulator_helper.dart';
import 'package:shop_app/utils/constants/colors.dart';

class ProductImageSilder extends StatelessWidget {
  const ProductImageSilder({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImagesController>(); 
    final images = controller.getAllProductImages(product);

    return Stack(
      children: [
        // ==================== ẢNH CHÍNH ====================
        Container(
          width: double.infinity,
          height: 420, 
          color: Colors.white,
          child: Center(
            child: Obx(() {
              final imageUrl = controller.selectedProductImage.value;
              // final fixedImageUrl = fixEmulatorImageUrl(imageUrl);

              return GestureDetector(
                onTap: () => controller.showEnlargedImage(imageUrl),
                child: Container(
                  width: double.infinity,
                  height: 420,
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover, 
                    alignment: Alignment.center,
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator(color: TColors.primary)),
                    errorWidget: (_, __, ___) => const Icon(Icons.error_outline, size: 60),
                  ),
                ),
              );
            }),
          ),
        ),

        // ==================== THUMBNAIL ====================
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 72,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, index) => Obx(() {
                final isSelected = controller.selectedProductImage.value == images[index];
                final fixedUrl = fixEmulatorImageUrl(images[index]);

                return GestureDetector(
                  onTap: () => controller.selectedProductImage.value = images[index],
                  child: Container(
                    width: 68, 
                    height: 68,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? TColors.primary : Colors.grey.shade300,
                        width: isSelected ? 3 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(imageUrl: fixedUrl, fit: BoxFit.cover),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
