import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shop_app/features/authentication/controller/onboarding/onboarding_controller.dart';
import 'package:shop_app/features/authentication/screens/onboarding/widgets/onboarding_btnn_next.dart';
import 'package:shop_app/features/authentication/screens/onboarding/widgets/onboarding_navigation.dart';
import 'package:shop_app/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:shop_app/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          // Hình ảnh
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                img: 'assets/onboarding/Onboarding-bro.png',
                title: 'Chào mừng đến với AppShop',
                subTitle: 'Đến với AppShop bạn sẽ có những trải nghiệm tuyệt vời!',
              ),
              OnBoardingPage(
                img: 'assets/onboarding/Onboarding-pana.png',
                title: 'Chào mừng đến với AppShop',
                subTitle: 'Đến với AppShop bạn sẽ có những trải nghiệm tuyệt vời!',
              ),
              OnBoardingPage(
                img: 'assets/onboarding/Onboarding-rafiki.png',
                title: 'Chào mừng đến với AppShop',
                subTitle: 'Đến với AppShop bạn sẽ có những trải nghiệm tuyệt vời!',
              ),
            ],
          ),
          // Nút skip
          OnBoardingSkip(),
          // Dấu chấm Navigation
          OnBoardingNavigation(),
          // Nút tiếp theo
          OnBoardingButtonNext(),
        ],
      ),
    );
  }
}
