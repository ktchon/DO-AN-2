import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/features/shop/controllers/products/image_controller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/helpers/emulator_helper.dart';
import 'package:shop_app/utils/constants/colors.dart';

class ProductImageSilder extends StatelessWidget {
  const ProductImageSilder({super.key, required this.product, required this.controllerTag});
  final ProductModel product;
  final String controllerTag;

  @override
  Widget build(BuildContext context) {
    // Tìm đúng controller theo tag
    final controller = Get.find<ImagesController>(tag: controllerTag);

    // Reset + Load ảnh mới mỗi khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadProductImages(product);
    });

    final images = controller.getAllProductImages(product);

    return Stack(
      children: [
        // Ảnh chính
        Container(
          width: double.infinity,
          height: 420,
          color: Colors.white,
          child: Obx(() {
            final imageUrl = controller.selectedProductImage.value.isNotEmpty
                ? controller.selectedProductImage.value
                : (product.thumbnail ?? '');

            return GestureDetector(
              onTap: () => controller.showEnlargedImage(imageUrl),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.error_outline, size: 60),
              ),
            );
          }),
        ),

        // Thumbnails
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
