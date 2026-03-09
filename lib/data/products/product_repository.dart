import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/exceptions/firebase_exceptions.dart';
import 'package:shop_app/utils/exceptions/platform_exceptions.dart';

/// Kho lưu trữ (Repository) dùng để quản lý dữ liệu và các thao tác liên quan đến sản phẩm.
class ProductRepository extends GetxController {
  /// Lấy instance duy nhất của ProductRepository thông qua GetX
  static ProductRepository get instance => Get.find();

  /// Instance của Firebase Firestore để tương tác với cơ sở dữ liệu.
  final _db = FirebaseFirestore.instance;

  /// Lấy danh sách sản phẩm nổi bật (featured), giới hạn 4 sản phẩm
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .limit(4)
          .get();

      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw CFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw CPlatformException(e.code).message;
    } catch (e) {
      throw 'Đã xảy ra lỗi. Vui lòng thử lại sau';
    }
  }

  /// Lấy danh sách sản phẩm nổi bật (featured),
  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
      final snapshot = await _db.collection('Products').where('IsFeatured', isEqualTo: true).get();

      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw CFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw CPlatformException(e.code).message;
    } catch (e) {
      throw 'Đã xảy ra lỗi. Vui lòng thử lại sau';
    }
  }

  /// Lấy danh sách sản phẩm dựa trên thương hiệu
  Future<List<ProductModel>> fetchProductsByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();

      final List<ProductModel> productList = querySnapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();

      return productList;
    } on FirebaseException catch (e) {
      throw CFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw CPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi gì đó xảy ra. Vui lòng thử lại';
    }
  }

  /// Lấy danh sách sản phẩm dựa trên danh sách ID cung cấp (Query)
  Future<List<ProductModel>> getFavouriteProducts(List<String> productIds) async {
    try {
      // Truy cập vào collection 'Products', tìm các tài liệu có ID nằm trong danh sách productIds
      final snapshot = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();

      // Chuyển đổi dữ liệu từ snapshot của Firebase thành danh sách các đối tượng ProductModel
      return snapshot.docs
          .map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot))
          .toList();
    } on FirebaseException catch (e) {
      // Xử lý lỗi riêng biệt từ Firebase
      throw CFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      // Xử lý lỗi từ nền tảng (iOS/Android)
      throw CPlatformException(e.code).message;
    } catch (e) {
      // Các lỗi không xác định khác
      throw 'Đã có lỗi xảy ra. Vui lòng thử lại sau.';
    }
  }

  // Lấy sản phẩm theo thương hiệu
  Future<List<ProductModel>> getProductsForBrand({required String brandId, int limit = -1}) async {
    try {
      final querySnapshot = limit == -1
          ? await _db.collection('Products').where('Brand.Id', isEqualTo: brandId).get()
          : await _db
                .collection('Products')
                .where('Brand.Id', isEqualTo: brandId)
                .limit(limit)
                .get();

      final products = querySnapshot.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();

      return products;
    } on FirebaseException catch (e) {
      throw CFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw CPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Lấy sản phẩm theo danh mục
  Future<List<ProductModel>> getProductsForCategory({
    required String categoryId,
    int limit = 6,
  }) async {
    try {
      final productCategoryQuery = limit == -1
          ? await _db.collection('ProductCategory').where('categoryId', isEqualTo: categoryId).get()
          : await _db
                .collection('ProductCategory')
                .where('categoryId', isEqualTo: categoryId)
                .limit(limit)
                .get();

      // Trích xuất danh sách productId từ các documents (thường là kết quả query từ collection liên kết category-product)
      List<String> productIDs = productCategoryQuery.docs
          .map((doc) => doc['productId'] as String)
          .toList();

      // Tạo query để lấy toàn bộ thông tin sản phẩm từ collection 'Products'
      // Dùng whereIn để lọc theo danh sách productIDs (lấy theo documentId của collection Products)
      final productsQuery = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIDs)
          .get();

      // Chuyển đổi dữ liệu từ các documents vừa lấy được thành List<ProductModel>
      List<ProductModel> products = productsQuery.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();

      return products;
    } on FirebaseException catch (e) {
      throw CFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw CPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
