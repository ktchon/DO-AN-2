import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/features/authentication/screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  /// Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  /// Update Current Index when Page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// Jump to the specific dot selected page (khi click vào dot indicator)
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  /// Update Current Index & jump to next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      final deviceStorage = GetStorage();
      if (kDebugMode) {
        print('========Lấy Kho Lưu Trữ Xác Thực========');
        print(deviceStorage.read("isFirstTime"));
      }
      deviceStorage.write("key", false);
      if (kDebugMode) {
        print('========Lấy Kho Lưu Trữ Xác Thực========');
        print(deviceStorage.read("isFirstTime"));
      }
      Get.to(const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  /// Skip to the last page
  void skipPage() {
    // currentPageIndex.value = 2;
    // pageController.jumpToPage(2);
    Get.offAll(() => LoginScreen());
  }
}
