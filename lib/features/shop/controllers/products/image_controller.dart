import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/constants/sizes.dart';
import 'package:shop_app/utils/helpers/emulator_helper.dart';

class ImagesController extends GetxController {
  static ImagesController get instance => Get.find();

  /// Biến
  RxString selectedProductImage = ''.obs;

  /// -- Lấy TẤT CẢ các ảnh từ sản phẩm chính và các biến thể (variation)
  List<String> getAllProductImages(ProductModel product) {
    // Sử dụng Set để chỉ thêm các ảnh duy nhất (tránh trùng lặp)
    Set<String> images = {};

    // Load ảnh thumbnail (ảnh đại diện nhỏ)
    images.add(product.thumbnail);

    // Gán Thumbnail làm ảnh được chọn mặc định
    selectedProductImage.value = product.thumbnail;

    // Lấy tất cả ảnh từ trường images của Product Model (nếu có)
    if (product.images != null) {
      images.addAll(product.images!);
    }

    // Lấy tất cả ảnh từ các biến thể sản phẩm (nếu có biến thể)
    if (product.productVariations != null || product.productVariations!.isNotEmpty) {
      images.addAll(product.productVariations!.map((variation) => variation.image));
    }

    return images.toList();
  }

  /// -- Hiển thị Popup ảnh phóng to (toàn màn hình)
  void showEnlargedImage(String image) {
    final fixedImageUrl = fixEmulatorImageUrl(image);
    Get.to(
      fullscreenDialog: true,
      transition: Transition.zoom, // (có thể bạn chưa viết, nhưng thường dùng zoom cho ảnh)
      () => Dialog.fullscreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Khoảng cách và hiển thị ảnh chính
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TSizes.defaultSpace * 2,
                horizontal: TSizes.defaultSpace,
              ),
              child: CachedNetworkImage(imageUrl: fixedImageUrl),
            ), // Padding
            /// Khoảng trống giữa ảnh và nút đóng
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Nút đóng nằm ở dưới cùng giữa màn hình
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                child: OutlinedButton(onPressed: () => Get.back(), child: const Text('Đóng')),
              ),
            ), 
          ],
        ), 
      ),
    );
  }
}
