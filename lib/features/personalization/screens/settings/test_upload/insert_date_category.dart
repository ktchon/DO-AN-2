import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/features/shop/models/category_model.dart';
import 'package:shop_app/utils/popups/loaders.dart';

Future<void> insertSampleCategories() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  // Khởi tạo danh sách 6 danh mục mẫu
  final List<CategoryModel> categories = [
    CategoryModel(id: '1', name: 'Điện thoại', image: 'url_anh_1', isFeatured: true),
    CategoryModel(id: '2', name: 'Laptop', image: 'url_anh_2', isFeatured: true),
    CategoryModel(id: '3', name: 'Thể thao', image: 'url_anh_3', isFeatured: true),
    CategoryModel(id: '4', name: 'Giày dép', image: 'url_anh_4', isFeatured: true),
  ];

  try {
    for (var category in categories) {
      // Sử dụng category.id làm Document ID thay vì để trống
      final docRef = firestore.collection('Categories').doc(category.id);

      batch.set(docRef, category.toJson());
    }

    await batch.commit();

    CLoaders.successSnackBar(
      title: 'Thành công!',
      message: 'Đã thêm ${categories.length} danh mục với ID từ 1 đến 4',
    );
  } catch (e) {
    CLoaders.errorSnackBar(title: 'Lỗi!', message: 'Không thể thêm danh mục: $e');
  }
}
