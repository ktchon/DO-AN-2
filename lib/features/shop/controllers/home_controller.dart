import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final bannerIndex = 0.obs;

  void updatePageIndicator(index) {
    bannerIndex.value = index;
  }
}
