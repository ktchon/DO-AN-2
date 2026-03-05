import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/features/shop/models/brand_model.dart';
import 'package:shop_app/features/shop/models/product_attribute_model.dart';
import 'package:shop_app/features/shop/models/product_variation_model.dart';

class ProductModel {
  final String id;
  String sku;
  String title;
  int stock;
  double price;
  double salePrice;
  bool isFeatured;
  String thumbnail;
  String categoryId;
  String description;
  String productType;
  BrandModel? brand;
  List<String> images;
  List<ProductAttributeModel>? productAttributes;
  List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    this.sku = '',
    this.title = '',
    this.stock = 0,
    this.price = 0.0,
    this.salePrice = 0.0,
    this.isFeatured = false,
    this.thumbnail = '',
    this.categoryId = '',
    this.description = '',
    this.productType = '',
    this.brand,
    this.images = const [],
    this.productAttributes,
    this.productVariations,
  });

  /// Json Format
  Map<String, dynamic> toJson() {
    return {
      'SKU': sku,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'SalePrice': salePrice,
      'IsFeatured': isFeatured,
      'CategoryId': categoryId,
      'Brand': brand?.toJson(),
      'Description': description,
      'ProductType': productType,
      'Images': images,
      'Thumbnail': thumbnail,
      'ProductAttributes': productAttributes != null
          ? productAttributes!.map((e) => e.toJson()).toList()
          : [],
      'ProductVariations': productVariations != null
          ? productVariations!.map((e) => e.toJson()).toList()
          : [],
    };
  }

  /// Create Empty func for clean code
  static ProductModel empty() => ProductModel(id: '', title: '', stock: 0, price: 0, thumbnail: '', productType: '');


  /// Map Json oriented document snapshot from Firebase to Model
  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if(document.data() == null) return ProductModel.empty();
    final data = document.data()!;

    return ProductModel(
      id: document.id,
      sku: data['SKU'] ?? '',
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      price: double.tryParse((data['Price'] ?? 0.0).toString()) ?? 0.0,
      salePrice: double.tryParse((data['SalePrice'] ?? 0.0).toString()) ?? 0.0,
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      images: data['Images'] != null ? List<String>.from(data['Images']) : const [],
      productAttributes: data['ProductAttributes'] != null
          ? (data['ProductAttributes'] as List<dynamic>)
                .map((e) => ProductAttributeModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      productVariations: data['ProductVariations'] != null
          ? (data['ProductVariations'] as List<dynamic>)
                .map((e) => ProductVariationModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  /// Map JSON-oriented document snapshot from Firebase to Model
  factory ProductModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;

    return ProductModel(
      id: document.id,
      sku: data['SKU'] ?? '',
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      price: double.tryParse((data['Price'] ?? 0.0).toString()) ?? 0.0,
      salePrice: double.tryParse((data['SalePrice'] ?? 0.0).toString()) ?? 0.0,
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      images: data['Images'] != null ? List<String>.from(data['Images']) : const [],
      productAttributes: data['ProductAttributes'] != null
          ? (data['ProductAttributes'] as List<dynamic>)
                .map((e) => ProductAttributeModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      productVariations: data['ProductVariations'] != null
          ? (data['ProductVariations'] as List<dynamic>)
                .map((e) => ProductVariationModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }
}
