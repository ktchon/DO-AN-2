import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/appbar/appbar.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_image.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/features/personalization/controllers/user/user_controller.dart';
import 'package:shop_app/features/personalization/screens/profile/change_name.dart';
import 'package:shop_app/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: Appbar(
        showBackArrow: true,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium!.apply(
            color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image = networkImage.isNotEmpty
                          ? networkImage
                          : 'assets/profile/user.png';

                      return controller.imageUploading.value
                          ? const CShimmerEffect(width: 80, height: 80, radius: 80)
                          : CircularImage(
                              image: image,
                              width: 80,
                              height: 80,
                              isNetworkImage: networkImage.isNotEmpty,
                            );
                    }),
                    TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: Text('Thay đổi ảnh đại diện'),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 16),
              SectionHeading(
                textTitle: 'Thông tin hồ sơ',
                textColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                showActionButton: false,
              ),
              SizedBox(height: 16),
              ProfileMenu(
                labelText: 'Tên',
                mainText: controller.user.value.fullName,
                onTap: () => Get.to(() => ChangeName()),
                icon: Iconsax.arrow_right_3_copy,
              ),
              ProfileMenu(
                labelText: 'Tên người dùng',
                mainText: controller.user.value.username,
                onTap: () {},
                icon: Iconsax.arrow_right_3_copy,
              ),
              SizedBox(height: 16),
              Divider(),
              SectionHeading(
                textTitle: 'Thông tin cá nhân',
                textColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                showActionButton: false,
              ),
              SizedBox(height: 16),
              ProfileMenu(
                labelText: 'ID người dùng',
                mainText: controller.user.value.id,
                onTap: () {},
                icon: Iconsax.copy_copy,
              ),
              ProfileMenu(
                labelText: 'Email',
                mainText: controller.user.value.email,
                onTap: () {},
                icon: Iconsax.arrow_right_3_copy,
              ),

              ProfileMenu(
                labelText: 'Số điện thoại',
                mainText: controller.user.value.phoneNumber,
                onTap: () {},
                icon: Iconsax.arrow_right_3_copy,
              ),
              ProfileMenu(
                labelText: 'Giới tính',
                mainText: 'Nam',
                onTap: () {},
                icon: Iconsax.arrow_right_3_copy,
              ),
              ProfileMenu(
                labelText: 'Ngày sinh',
                mainText: '28/01/2005',
                onTap: () {},
                icon: Iconsax.arrow_right_3_copy,
              ),
              Divider(),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: Text('Xoá tài khoản', style: TextStyle(color: Colors.red)),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
