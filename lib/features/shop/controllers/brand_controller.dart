import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/data/brands/brand_repository.dart';
import 'package:shop_app/data/products/product_repository.dart';
import 'package:shop_app/features/shop/models/brand_model.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/popups/loaders.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  RxBool isLoading = true.obs;
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  final brandRepository = Get.put(BrandRepository());

  @override
  void onInit() {
    getFeaturedBrands();
    super.onInit();
  }

  /// -- Tải dữ liệu các thương hiệu (Load Brands)
  Future<void> getFeaturedBrands() async {
    try {
      // Hiển thị vòng lặp chờ (loader) trong khi đang tải dữ liệu
      isLoading.value = true;

      final brands = await brandRepository.getAllBrands();

      allBrands.assignAll(brands);

      featuredBrands.assignAll(allBrands.where((brand) => brand.isFeatured ?? false).take(4));
    } catch (e) {
      CLoaders.errorSnackBar(title: 'Có lỗi xảy ra', message: e.toString());
    } finally {
      // Tắt vòng lặp chờ sau khi hoàn tất
      isLoading.value = false;
    }
  }

  /// -- Lấy thương hiệu cho danh mục
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      final brands = await brandRepository.getBrandsForCategory(categoryId);
      return brands;
    } catch (e) {
      CLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    }
  }

  /// Lấy các sản phẩm cụ thể của Thương hiệu từ nguồn dữ liệu của bạn
  Future<List<ProductModel>> getBrandProducts({required String brandId, int limit = -1}) async {
    try {
      // Gọi đến ProductRepository để lấy sản phẩm theo ID thương hiệu
      final products = await ProductRepository.instance.getProductsForBrand(
        brandId: brandId,
        limit: limit,
      );
      return products;
    } catch (e) {
      // Hiển thị thông báo lỗi nếu có sự cố xảy ra
      CLoaders.errorSnackBar(title: 'Đã có lỗi xảy ra!', message: e.toString());
      return [];
    }
  }
}
