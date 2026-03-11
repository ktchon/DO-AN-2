import 'package:get/get.dart';
import 'package:shop_app/data/products/product_repository.dart';
import 'package:shop_app/data/repositories/categories/category_repository.dart';
import 'package:shop_app/features/shop/models/category_model.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/popups/loaders.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  /// -- Tải dữ liệu danh mục
  Future<void> fetchCategories() async {
    try {
      // Hiển thị loader trong khi đang tải danh mục
      isLoading.value = true;

      // Lấy danh mục từ nguồn dữ liệu (Firestore, API, v.v.)
      final categories = await _categoryRepository.getAllCategories();

      // Cập nhật danh sách danh mục
      allCategories.assignAll(categories);

      // Lọc các danh mục nổi bật (featured)
      featuredCategories.assignAll(
        allCategories
            .where((category) => category.isFeatured && category.parentId.isEmpty)
            .take(8)
            .toList(),
      );
    } catch (e) {
      CLoaders.errorSnackBar(title: 'Có gì đó không ổn!', message: e.toString());
    } finally {
      // Ẩn loader
      isLoading.value = false;
    }
  }

  // Hàm bất đồng bộ, trả về một Future chứa danh sách các CategoryModel
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final subCategories = await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    } catch (e) {
      CLoaders.errorSnackBar(title: 'Đã có lỗi xảy ra!', message: e.toString());
      return [];
    }
  }

  /// Lấy sản phẩm của Danh mục hoặc Danh mục con.
  Future<List<ProductModel>> getCategoryProducts({
    required String categoryId,
    int limit = 4,
  }) async {
    // Ghi chú: Lấy giới hạn (ở đây mặc định 4) sản phẩm
    // tương ứng với mỗi danh mục con (subCategory) hoặc danh mục chính

    final products = await ProductRepository.instance.getProductsForCategory(
      categoryId: categoryId,
      limit: limit,
    );

    return products;
  }
}
