import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/icons/circular_icon.dart';
import 'package:shop_app/features/shop/controllers/products/favourites_controller.dart';

class CFavouriteIcon extends StatelessWidget {
  const CFavouriteIcon({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouritesController());
    return Obx(
      () => CircularIcon(
        icon: controller.isFavourite(productId) ? Iconsax.heart : Iconsax.heart_copy,
        size: 20,
        color: controller.isFavourite(productId) ? Colors.red : null,
        onPressed: () => controller.toggleFavoriteProduct(productId),
      ),
    );
  }
}
