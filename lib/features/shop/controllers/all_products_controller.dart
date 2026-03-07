import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/data/products/product_repository.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/popups/loaders.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();
  final RxString selectedSortOption = 'Name'.obs;
  final repository = ProductRepository.instance;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async {
    try {
      if (query == null) return [];

      final products = await repository.fetchProductsByQuery(query);

      return products;
    } catch (e) {
      CLoaders.errorSnackBar(title: 'Có gì đó không ổn!', message: e.toString());
      return [];
    }
  }

  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;

    switch (sortOption) {
      case 'Name':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;

      case 'Giá cao':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;

      case 'Giá thấp':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;

      case 'Hàng mới':
        products.sort((a, b) => a.date!.compareTo(b.date!));
        break;

      case 'Giảm giá':
        products.sort((a, b) {
          if (b.salePrice > 0) {
            return b.salePrice.compareTo(a.salePrice);
          } else if (a.salePrice > 0) {
            return -1;
          } else {
            return 1;
          }
        });
        break;

      default:
        // Default sorting option: Name
        products.sort((a, b) => a.title.compareTo(b.title));
    }
  }

  void assignProducts(List<ProductModel> products) {
    // Assign products to the 'products' list
    this.products.assignAll(products);
    sortProducts('Name');
  }
}
