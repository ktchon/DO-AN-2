import 'dart:async';

import 'package:get/get.dart';
import 'package:shop_app/features/shop/controllers/search/search_controller.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final bannerIndex = 0.obs;
  RxString hintText = 'Tìm kiếm sản phẩm...'.obs;

  List<String> suggestions = [];
  int index = 0;
  Timer? timer;

  final cSearch = Get.find<CSearchController>();

  void updatePageIndicator(index) {
    bannerIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  void _initData() async {
    await Future.delayed(const Duration(milliseconds: 400)); 

    suggestions = [...cSearch.recentSearches.take(5), ...cSearch.trendingSearches.take(5)];

    if (suggestions.isEmpty) {
      suggestions = ['Tìm kiếm sản phẩm...','Giày dép thời trang...', 'Quần áo thời trang...', 'Điện thoại mới nhất...'];
    }

    suggestions = suggestions.toSet().toList();
    suggestions.shuffle();

    timer?.cancel();
    index = 0;
    hintText.value = suggestions[index]; 

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      index = (index + 1) % suggestions.length;
      hintText.value = suggestions[index];
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
