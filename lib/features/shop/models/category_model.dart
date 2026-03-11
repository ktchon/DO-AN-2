import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String parentId;
  final bool isFeatured;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isFeatured,
    this.parentId = '',
  });

  /// Hàm helper tạo đối tượng rỗng
  static CategoryModel empty() => CategoryModel(id: '', name: '', image: '', isFeatured: false);

  /// Chuyển đổi model thành cấu trúc JSON (Map) để lưu vào Firestore
  Map<String, dynamic> toJson() {
    return {'Name': name, 'Image': image, 'ParentId': parentId, 'IsFeatured': isFeatured};
  }

  /// Factory để chuyển từ DocumentSnapshot của Firestore sang đối tượng model
  factory CategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return CategoryModel(
        id: document.id, // Lấy ID của document từ Firestore
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        parentId: data['ParentId'] ?? '',
        isFeatured: data['IsFeatured'] ?? false,
      );
    } else {
      // Trường hợp document không tồn tại hoặc dữ liệu là null
      return CategoryModel.empty();
    }
  }
}
