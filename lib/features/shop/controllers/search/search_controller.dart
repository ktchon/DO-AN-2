import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/data/search/search_repository.dart';
import 'package:shop_app/features/shop/screens/all_products/all_products.dart';
import 'package:shop_app/features/shop/screens/product-details/product_detail.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import '../../models/product_model.dart';

class CSearchController extends GetxController {
  static CSearchController get instance => Get.find();

  final searchTextController = TextEditingController();
  final searchRepo = Get.put(SearchRepository());

  var isLoading = false.obs;
  RxList<ProductModel> suggestions = <ProductModel>[].obs;
  RxList<String> recentSearches = <String>[].obs;
  RxList<String> trendingSearches = <String>[].obs;
  RxString searchQuery = ''.obs;

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
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 180), () async {
      final cleanQuery = query.trim();
      if (cleanQuery.isEmpty) {
        suggestions.clear();
        return;
      }

      isLoading.value = true;
      try {
        suggestions.value = await searchRepo.getAutocompleteSuggestions(cleanQuery);
        print('✅ Tìm thấy ${suggestions.length} gợi ý cho: "$cleanQuery"');
      } catch (e) {
        print('❌ Lỗi tìm kiếm: $e');
        suggestions.clear();
      } finally {
        isLoading.value = false;
      }
    });
  }

  // Khi nhấn tìm kiếm (Enter hoặc chọn từ danh sách)
  void searchKeyword(String keyword) async {
    if (keyword.isEmpty) return;

    final cleanKeyword = THelperFunctions.removeDiacritics(keyword.toLowerCase());

    searchTextController.text = keyword;
    searchQuery.value = keyword;

    await _saveSearchHistory(keyword);

    Get.to(
      () => AllProductsScreen(
        title: keyword,
        query: FirebaseFirestore.instance
            .collection('Products')
            .where('SearchName', isGreaterThanOrEqualTo: cleanKeyword)
            .where('SearchName', isLessThanOrEqualTo: '$cleanKeyword\uf8ff'),
      ),
    );
  }

  void clearRecent() async {
    recentSearches.clear();
  }

  void navigateToProductDetail(ProductModel product) async {
    await _saveSearchHistory(product.title);
    Get.to(() => ProductDetail(product: product));
  }

  Future<void> _saveSearchHistory(String keyword) async {
    if (keyword.isEmpty) return;
    await searchRepo.saveSearchHistory(userId, keyword);

    recentSearches.remove(keyword);
    recentSearches.insert(0, keyword);
  }
}
