import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/data/products/product_repository.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/features/shop/models/product_model.dart';

class RecommendationController extends GetxController {
  static RecommendationController get instance => Get.find();

  final repo = ProductRepository.instance;
  RxList<ProductModel> similarProducts = <ProductModel>[].obs;
  RxList<ProductModel> complementaryProducts = <ProductModel>[].obs;
  RxList<ProductModel> historyBasedProducts = <ProductModel>[].obs;

  Future<void> loadRecommendationsForProduct(ProductModel product) async {
    if (product.id == null || product.id!.isEmpty) return;

    print("🔄 Đang load gợi ý cho sản phẩm: ${product.id} - ${product.title}");

    try {
      // Lấy brandId từ map Brand
      final brandMap = product.toJson()['Brand'] as Map<String, dynamic>? ?? {};
      final brandId = brandMap['Id'] as String? ?? '';

      // Similar Products
      similarProducts.value = await repo.getSimilarProducts(
        productId: product.id!,
        categoryId: product.categoryId ?? '',
        brandId: brandId,
      );

      // Complementary Products
      complementaryProducts.value = await repo.getComplementaryProducts(
        product.complementaryProductIds ?? [],
      );

      similarProducts.refresh();
      complementaryProducts.refresh();

      print(
        "✅ Final - Similar: ${similarProducts.length} | Complementary: ${complementaryProducts.length}",
      );
    } catch (e) {
      print("❌ Load recommendations error: $e");
    }
  }

  Future<void> loadHistoryBasedRecommendations() async {
    final userId = AuthenticationRepository.instance.authUser?.uid;
    if (userId == null) return;
    historyBasedProducts.value = await repo.getRecommendationsFromPurchaseHistory(userId);
  }
}
