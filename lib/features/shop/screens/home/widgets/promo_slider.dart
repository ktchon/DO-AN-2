import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shop_app/common/images/banner_images.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';
import 'package:shop_app/features/shop/controllers/banner_controller.dart';

class PromoSlider extends StatelessWidget {
  const PromoSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    return Obx(() {
      if (controller.isLoading.value) return CShimmerEffect(width: double.infinity, height: 190);

      if (controller.banners.isEmpty) {
        return Center(child: Text('Không tìm thấy dữ liệu!'));
      } else {
        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                onPageChanged: (index, _) => controller.carousalCurrentIndex.value = index,
              ),
              items: controller.banners
                  .map(
                    (banner) => BannerImage(
                      fit: BoxFit.cover,
                      imageUrl: banner.imageUrl,
                      backgroundColor: Colors.white,
                      borderRadius: 16,
                      isNetworkImage: true,
                      onPressed: () => Get.toNamed(banner.targetScreen),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 8),
            Center(
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < controller.banners.length; i++)
                      CircularContainer(
                        height: 4,
                        width: 20,
                        margin: EdgeInsets.only(right: 10),
                        backgroundColor: controller.carousalCurrentIndex.value == i
                            ? Colors.green
                            : Colors.grey,
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    });
  }
}
