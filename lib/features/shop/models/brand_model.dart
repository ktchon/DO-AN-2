import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String id;
  String name;
  String image;
  bool isFeatured;
  int? productsCount;

  BrandModel({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured = false,
    this.productsCount,
  });

  /// Empty Helper Function
  static BrandModel empty() => BrandModel(id: '', name: '', image: '');

  /// Convert model to JSON structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'IsFeatured': isFeatured,
      'ProductsCount': productsCount,
    };
  }

  /// Map JSON oriented document from Firebase to BrandModel
  factory BrandModel.fromJson(Map<String, dynamic> document) {
    final data = document;

    if (data.isEmpty) {
      return BrandModel.empty();
    }

    return BrandModel(
      id: data['Id'] ?? '',
      name: data['Name'] ?? '',
      image: data['Image'] ?? '',
      isFeatured: data['IsFeatured'] ?? false,
      productsCount: data['ProductsCount'] != null
          ? int.tryParse((data['ProductsCount'] ?? 0).toString()) ?? 0
          : null,
    );
  }

  /// Map from DocumentSnapshot (Firestore) to BrandModel
  factory BrandModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (!document.exists || document.data() == null) {
      return BrandModel.empty();
    }

    final data = document.data()!;

    return BrandModel(
      id: document.id,
      name: data['Name'] ?? '',
      image: data['Image'] ?? '',
      isFeatured: data['IsFeatured'] ?? false,
      productsCount: data['ProductsCount'] != null
          ? int.tryParse((data['ProductsCount'] ?? 0).toString()) ?? 0
          : null,
    );
  }
}
