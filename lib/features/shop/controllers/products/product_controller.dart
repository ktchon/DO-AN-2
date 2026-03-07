import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/data/products/product_repository.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/popups/loaders.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());

  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  void fetchFeaturedProducts() async {
    try {
      // Show loader while loading Products
      isLoading.value = true;

      // Fetch Products
      final products = await productRepository.getFeaturedProducts();

      // Assign Products
      featuredProducts.assignAll(products);
    } catch (e) {
      CLoaders.errorSnackBar(title: 'Có gì đó không ổn!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
      // Fetch Products
      final products = await productRepository.getFeaturedProducts();
      return products;
    } catch (e) {
      CLoaders.errorSnackBar(title: 'Có gì đó không ổn!', message: e.toString());
      return [];
    }
  }

  /// Lấy giá sản phẩm hoặc khoảng giá (nếu có nhiều biến thể)
  num getProductPrice(ProductModel product) {
    // Sản phẩm đơn
    if (product.productType == ProductType.single.toString()) {
      return product.salePrice > 0 ? product.salePrice : product.price;
    }

    // Sản phẩm có biến thể
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    for (var variation in product.productVariations!) {
      double priceToConsider = variation.salePrice > 0 ? variation.salePrice : variation.price;

      if (priceToConsider < smallestPrice) {
        smallestPrice = priceToConsider;
      }

      if (priceToConsider > largestPrice) {
        largestPrice = priceToConsider;
      }
    }

    // Nếu bằng nhau → trả 1 giá
    if (smallestPrice == largestPrice) {
      return smallestPrice;
    }

    // Nếu là khoảng giá → trả giá nhỏ nhất (UI xử lý tiếp nếu muốn)
    return smallestPrice;
  }

  /// Tính phần trăm giảm giá
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// -- Kiểm tra trạng thái tồn kho sản phẩm
  String getProductStockStatus(int stock) {
    return stock > 0 ? 'Còn hàng' : 'Hết hàng';
  }
}
