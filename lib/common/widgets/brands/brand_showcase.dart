import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/widgets/brands/brand_card.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';
import 'package:shop_app/features/shop/models/brand_model.dart';
import 'package:shop_app/features/shop/screens/brands/product_brand.dart';
import 'package:shop_app/utils/helpers/emulator_helper.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class BrandShowcase extends StatelessWidget {
  const BrandShowcase({
    super.key,
    required this.images,
    required this.brand,
  });

  final BrandModel brand;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: () => Get.to(() => ProductBrandScreen(brand: brand)),
      child: RoundedContainer(
        margin: const EdgeInsets.all(16),
        showBorder: true,
        borderColor: Colors.green,
        backgroundColor: isDark ? Colors.black : Colors.white,
        child: Column(
          children: [
            BrandCard(brand: brand),

            // ==================== PHẦN ẢNH SẢN PHẨM - ĐẸP VỚI 2 & 3 ẢNH ====================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,   // Căn giữa để 2 ảnh và 3 ảnh đều đẹp
                children: List.generate(images.length, (index) {
                  final fixedUrl = fixEmulatorImageUrl(images[index]);

                  return Expanded(
                    child: Container(
                      height: 100,                          // Chiều cao đẹp, rõ ràng
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 8,
                        right: index == images.length - 1 ? 0 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.grey.shade700 : Colors.green.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: fixedUrl,
                          fit: BoxFit.cover,               // Ảnh luôn đầy khung
                          alignment: Alignment.center,
                          placeholder: (_, __) => const CShimmerEffect(height: 140, width: 100,),
                          errorWidget: (_, __, ___) => const Icon(Icons.error_outline, size: 40),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}