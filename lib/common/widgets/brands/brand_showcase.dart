import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shop_app/common/widgets/brands/brand_card.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';
import 'package:shop_app/features/shop/models/brand_model.dart';
import 'package:shop_app/features/shop/screens/brands/product_brand.dart';
import 'package:shop_app/utils/helpers/emulator_helper.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class BrandShowcase extends StatelessWidget {
  const BrandShowcase({super.key, required this.images, required this.brand});

  final BrandModel brand;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(ProductBrandScreen(brand: brand)),
      child: RoundedContainer(
        margin: EdgeInsets.all(16),
        showBorder: true,
        borderColor: Colors.green,
        backgroundColor: THelperFunctions.isDarkMode(context) ? Colors.black : Colors.white,
        child: Column(
          children: [
            BrandCard(brand: brand),
            Row(children: images.map((image) => BrandTopProductWidget(image, context)).toList()),
          ],
        ),
      ),
    );
  }

  Widget BrandTopProductWidget(String image, context) {
    final fixImageNetwork = fixEmulatorImageUrl(image);
    return Expanded(
      child: RoundedContainer(
        showBorder: true,
        backgroundColor: THelperFunctions.isDarkMode(context) ? Colors.grey : Colors.white,
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(0),
        borderColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.green,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl:
                fixImageNetwork, // URL của hình ảnh sản phẩm (thường từ Firebase Storage hoặc CDN)
            // Widget hiển thị trong lúc đang tải ảnh (progress)
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                const CShimmerEffect(width: 100, height: 100),

            // Widget hiển thị nếu tải ảnh thất bại (error)
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ), // CachedNetworkImage
        ),
      ),
    );
  }
}
