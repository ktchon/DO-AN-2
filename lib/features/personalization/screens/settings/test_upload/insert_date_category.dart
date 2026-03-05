import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/features/shop/models/category_model.dart';
import 'package:shop_app/utils/popups/loaders.dart';

Future<void> insertSampleCategories() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  final List<CategoryModel> categories = [
    CategoryModel(id: '', name: 'Điện thoại', image: '', isFeatured: true),
    CategoryModel(id: '', name: 'Laptop', image: '', isFeatured: true),
  ];

  try {
    for (var category in categories) {
      final docRef = firestore.collection('Categories').doc();
      batch.set(docRef, category.toJson());
    }

    await batch.commit();

    CLoaders.successSnackBar(
      title: 'Thành công!',
      message: 'Đã thêm ${categories.length} danh mục mẫu vào Firestore',
    );
  } catch (e) {
    CLoaders.errorSnackBar(title: 'Lỗi!', message: 'Không thể thêm danh mục: $e');
  }
}
