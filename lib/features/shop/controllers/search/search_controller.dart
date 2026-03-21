import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/data/search/search_repository.dart';
import 'package:shop_app/features/shop/screens/all_products/all_products.dart';
import 'package:shop_app/features/shop/screens/product-details/product_detail.dart';
import '../../models/product_model.dart';

class CSearchController extends GetxController {
  static CSearchController get instance => Get.find();

  final searchTextController = TextEditingController();
  final searchRepo = Get.put(SearchRepository());

  var isLoading = false.obs;
  RxList<ProductModel> suggestions = <ProductModel>[].obs;
  RxList<String> recentSearches = <String>[].obs;
  RxList<String> trendingSearches = <String>[].obs;

  Timer? _debounce;
  String userId = AuthenticationRepository.instance.authUser!.uid;

  @override
  void onInit() {
    fetchInitialData();
    super.onInit();
  }

  void fetchInitialData() async {
    trendingSearches.value = await searchRepo.getTrendingSearches();
    recentSearches.value = await searchRepo.getRecentSearches(userId);
  }

  // Autocomplete realtime
  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.trim().isNotEmpty) {
        isLoading.value = true;
        suggestions.value = await searchRepo.getAutocompleteSuggestions(query.trim());
        isLoading.value = false;
      } else {
        suggestions.clear();
      }
    });
  }

  // Khi nhấn tìm kiếm (Enter hoặc chọn từ danh sách)
  void searchKeyword(String keyword) async {
    if (keyword.isEmpty) return;

    searchTextController.text = keyword;
    await searchRepo.saveSearchHistory(userId, keyword);

    // Cập nhật lại list Recent local để UI thay đổi ngay
    recentSearches.remove(keyword);
    recentSearches.insert(0, keyword);

    Get.to(
      () => AllProductsScreen(
        title: keyword,
        query: FirebaseFirestore.instance
            .collection('Products')
            .where('Title', isGreaterThanOrEqualTo: keyword),
      ),
    );
  }

  void clearRecent() async {
    recentSearches.clear();
    // Logic xóa trên Firebase nếu cần
  }

  void navigateToProductDetail(ProductModel product) {
    searchKeyword(product.title);
    Get.to(() => ProductDetail(product: product));
  }
}
