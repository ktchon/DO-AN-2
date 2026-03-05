import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String imageUrl; // URL ảnh banner từ Firebase Storage
  final String targetScreen; // Màn hình đích khi click (ví dụ: 'ProductScreen', 'CategoryScreen')
  final bool active; // Banner có hiển thị không

  BannerModel({required this.imageUrl, required this.targetScreen, required this.active});

  // Constructor named để dễ dùng
  BannerModel copyWith({String? imageUrl, String? targetScreen, bool? active}) {
    return BannerModel(
      imageUrl: imageUrl ?? this.imageUrl,
      targetScreen: targetScreen ?? this.targetScreen,
      active: active ?? this.active,
    );
  }

  // Chuyển model thành Map để lưu lên Firestore
  Map<String, dynamic> toJson() {
    return {'imageUrl': imageUrl, 'targetScreen': targetScreen, 'active': active};
  }

  // Factory để parse từ Firestore document
  factory BannerModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};

    return BannerModel(
      imageUrl: (data['imageUrl'] ?? data['ImageUrl'] ?? data['imageURL'] ?? '') as String,
      targetScreen: (data['targetScreen'] ?? data['TargetScreen'] ?? '') as String,
      active: (data['active'] ?? data['Active'] ?? false) as bool,
    );
  }

  // Optional: Nếu bạn muốn hỗ trợ parse từ Map (ví dụ từ JSON API)
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      imageUrl: json['imageUrl'] as String? ?? '',
      targetScreen: json['targetScreen'] as String? ?? '',
      active: json['active'] as bool? ?? false,
    );
  }
}
