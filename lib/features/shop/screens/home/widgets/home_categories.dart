import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/common/widgets/image_text_widget/vertical_image_text.dart';
import 'package:shop_app/common/widgets/shimmer/category_shimmer.dart';
import 'package:shop_app/features/shop/controllers/category_controller.dart';
import 'package:shop_app/features/shop/screens/sub_category/sub_categoryes.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerCategory = Get.put(CategoryController());
    return Obx(() {
      if (controllerCategory.isLoading.value) return const CCategoryShimmer();

      if (controllerCategory.featuredCategories.isEmpty) {
        return Text(
          'Trống',
          style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
        );
      }

      return SizedBox(
        height: 80,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: controllerCategory.featuredCategories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final category = controllerCategory.featuredCategories[index];
            return VerticalImageText(
              image: category.image,
              title: category.name,
              onTap: () => Get.to(() => SubCategoryScreen()),
            );
          },
        ),
      );
    });
  }
}
