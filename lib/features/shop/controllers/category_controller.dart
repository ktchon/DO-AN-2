import 'package:get/get.dart';
import 'package:shop_app/data/repositories/categories/category_repository.dart';
import 'package:shop_app/features/shop/models/category_model.dart';
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
      featuredCategories.assignAll(allCategories
          .where((category) =>
              category.isFeatured && category.parentId.isEmpty)
          .take(8)
          .toList());
    } catch (e) {
      CLoaders.errorSnackBar(title: 'Có gì đó không ổn!', message: e.toString());
    } finally {
      // Ẩn loader
      isLoading.value = false;
    }
  }

  /// -- Tải dữ liệu danh mục đã chọn

  /// Lấy sản phẩm của Danh mục hoặc Danh mục con.
}