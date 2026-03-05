import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_image.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';
import 'package:shop_app/features/personalization/controllers/user/user_controller.dart';
import 'package:shop_app/features/personalization/screens/profile/profile.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return ListTile(
      leading: Obx(() {
        final networkImage = controller.user.value.profilePicture;
        final image = networkImage.isNotEmpty ? networkImage : 'assets/profile/user.png';

        return controller.imageUploading.value
            ? const CShimmerEffect(width: 50, height: 50, radius: 50)
            : CircularImage(
                image: image,
                width: 50,
                height: 50,
                padding: 0,
                isNetworkImage: networkImage.isNotEmpty,
              );
      }),
      title: Obx(() {
        if (controller.profileLoading.value) {
          return CShimmerEffect(width: 80, height: 15);
        } else {
          return Text(
            controller.user.value.fullName,
            style: Theme.of(context).textTheme.headlineSmall!.apply(color: Colors.white),
          );
        }
      }),
      subtitle: Obx(() {
        if (controller.profileLoading.value) {
          return CShimmerEffect(width: 120, height: 15);
        } else {
          return Text(
            controller.user.value.email,
            style: Theme.of(context).textTheme.bodySmall!.apply(color: Colors.white),
          );
        }
      }),
      trailing: IconButton(
        onPressed: () => Get.to(ProfileScreen()),
        icon: Icon(Iconsax.edit_copy, color: Colors.white),
      ),
    );
  }
}
