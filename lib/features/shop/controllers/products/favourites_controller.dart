import 'dart:convert';

import 'package:get/get.dart';
import 'package:shop_app/data/products/product_repository.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/popups/loaders.dart';
import 'package:shop_app/utils/storage/storage_utility.dart';

class FavouritesController extends GetxController {
  static FavouritesController get instance => Get.find();

  // Variable
  final favorites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initFavorites();
  }

  // Phương thức để khởi tạo danh sách yêu thích bằng cách đọc từ bộ nhớ
  void initFavorites() {
    final json = CLocalStorage.instance().readData('favorites');
    if (json != null) {
      final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
      favorites.assignAll(storedFavorites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  bool isFavourite(String productId) {
    return favorites[productId] ?? false;
  }

  void toggleFavoriteProduct(String productId) {
    if (!favorites.containsKey(productId)) {
      favorites[productId] = true;
      saveFavoritesToStorage();
      CLoaders.customToast(message: 'Sản phẩm đã được thêm vào Danh sách yêu thích.');
    } else {
      CLocalStorage.instance().removeData(productId);
      favorites.remove(productId);
      saveFavoritesToStorage();
      favorites.refresh();
      CLoaders.customToast(message: 'Sản phẩm đã được xóa khỏi Danh sách yêu thích.');
    }
  }

  void saveFavoritesToStorage() {
    final encodedFavorites = json.encode(favorites);
    CLocalStorage.instance().saveData('favorites', encodedFavorites);
  }

  // Phương thức bất đồng bộ để lấy danh sách các đối tượng ProductModel mà người dùng đã yêu thích
  Future<List<ProductModel>> favoriteProducts() async {
    // Đợi và trả về danh sách sản phẩm từ ProductRepository bằng cách truyền vào danh sách các ID (keys) từ map favorites
    return await ProductRepository.instance.getFavouriteProducts(favorites.keys.toList());
  }
}
