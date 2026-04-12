import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/features/shop/models/category_model.dart';
import 'package:shop_app/utils/popups/loaders.dart';

Future<void> insertSampleCategories() async {
  final firestore = FirebaseFirestore.instance;

  // ==================== 4 DANH MỤC MỚI BẠN MUỐN THÊM MỖI LẦN ====================
  final List<CategoryModel> newCategories = [
    CategoryModel(id: '', name: 'Đồng hồ', image: 'https://example.com/dongho.jpg', isFeatured: true),
    CategoryModel(id: '', name: 'Tai nghe', image: 'https://example.com/tainghe.jpg', isFeatured: true),
    CategoryModel(id: '', name: 'Máy tính bảng', image: 'https://example.com/tablet.jpg', isFeatured: true),
    CategoryModel(id: '', name: 'Phụ kiện', image: 'https://example.com/phukien.jpg', isFeatured: false),
  ];

  int addedCount = 0;

  try {
    // Lấy ID lớn nhất hiện tại để tiếp tục đánh số
    final snapshot = await firestore.collection('Categories').get();

    int maxId = 0;
    for (var doc in snapshot.docs) {
      final idNum = int.tryParse(doc.id) ?? 0;
      if (idNum > maxId) maxId = idNum;
    }

    int nextId = maxId + 1;

    final batch = firestore.batch();

    for (var category in newCategories) {
      final String newDocId = nextId.toString().padLeft(3, '0'); // 001, 002, 003...

      // Tạo bản sao với ID mới
      final categoryToAdd = CategoryModel(
        id: newDocId,
        name: category.name,
        image: category.image,
        isFeatured: category.isFeatured,
      );

      final docRef = firestore.collection('Categories').doc(newDocId);
      batch.set(docRef, categoryToAdd.toJson());

      nextId++;
      addedCount++;
    }

    await batch.commit();

    CLoaders.successSnackBar(
      title: 'Thành công!',
      message: 'Đã thêm $addedCount danh mục mới.\nID tiếp theo là $nextId',
    );
  } catch (e) {
    CLoaders.errorSnackBar(title: 'Lỗi!', message: 'Không thể thêm danh mục: $e');
  }
}