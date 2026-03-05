import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shop_app/features/authentication/controller/login/login_controller.dart';
import 'package:shop_app/utils/constants/colors.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          width: 40,
          height: 40,
          child: IconButton(
            onPressed: () => controller.googleSignIn(),
            icon: Image(image: AssetImage('assets/logo/google-logo.png')),
          ),
        ),
        SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          width: 40,
          height: 40,
          child: Image.asset("assets/logo/facebook-logo.png"),
        ),
      ],
    );
  }
}
