import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/helpers/emulator_helper.dart';

class ImagesController extends GetxController {
  static ImagesController get instance => Get.find();

  final RxString selectedProductImage = ''.obs;

  // Reset hoàn toàn controller
  void reset() {
    selectedProductImage.value = '';
  }

  // Load ảnh cho sản phẩm mới
  void loadProductImages(ProductModel product) {
    reset(); // Reset trước

    final Set<String> imageSet = {};

    // Thumbnail
    if (product.thumbnail != null && product.thumbnail!.isNotEmpty) {
      imageSet.add(product.thumbnail!);
      selectedProductImage.value = product.thumbnail!;
    }

    // Images array
    if (product.images != null && product.images!.isNotEmpty) {
      imageSet.addAll(product.images!);
    }

    // Variations
    if (product.productVariations != null) {
      for (var variation in product.productVariations!) {
        if (variation.image != null && variation.image!.isNotEmpty) {
          imageSet.add(variation.image!);
        }
      }
    }

    // Nếu chưa có ảnh nào, lấy cái đầu tiên
    if (selectedProductImage.value.isEmpty && imageSet.isNotEmpty) {
      selectedProductImage.value = imageSet.first;
    }
  }

  List<String> getAllProductImages(ProductModel product) {
    final Set<String> imageSet = {};

    if (product.thumbnail != null) imageSet.add(product.thumbnail!);
    if (product.images != null) imageSet.addAll(product.images!);

    if (product.productVariations != null) {
      for (var v in product.productVariations!) {
        if (v.image != null) imageSet.add(v.image!);
      }
    }

    return imageSet.toList();
  }

  void showEnlargedImage(String image) {
    final fixedImageUrl = fixEmulatorImageUrl(image);
    Get.to(
      () => Dialog.fullscreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CachedNetworkImage(imageUrl: fixedImageUrl, fit: BoxFit.contain),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 150,
              child: OutlinedButton(onPressed: () => Get.back(), child: const Text('Đóng')),
            ),
          ],
        ),
      ),
      fullscreenDialog: true,
      transition: Transition.zoom,
    );
  }
}
