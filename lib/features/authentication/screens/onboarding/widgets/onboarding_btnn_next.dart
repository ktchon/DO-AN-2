import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/features/authentication/controller/onboarding/onboarding_controller.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class OnBoardingButtonNext extends StatelessWidget {
  const OnBoardingButtonNext({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Positioned(
      right: 24,
      bottom: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: dark ? Colors.blue : Colors.black,
        ),
        onPressed: () => OnBoardingController.instance.nextPage(),
        child: Icon(Iconsax.arrow_right_3_copy),
      ),
    );
  }
}
