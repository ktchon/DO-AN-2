import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shop_app/features/shop/models/category_model.dart';
import 'package:shop_app/utils/exceptions/firebase_exceptions.dart';
import 'package:shop_app/utils/exceptions/platform_exceptions.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  /// Biến
  final _db = FirebaseFirestore.instance;

  /// Lấy tất cả danh mục
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('Categories').get();
      final list = snapshot.docs.map((document) => CategoryModel.fromSnapshot(document)).toList();
      return list;
    } on FirebaseException catch (e) {
      throw CFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw CPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  /// Lấy danh mục con
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final snapshot = await _db
          .collection("Categories")
          .where('ParentId', isEqualTo: categoryId)
          .get();

      final result = snapshot.docs.map((e) => CategoryModel.fromSnapshot(e)).toList();

      return result;
    } on FirebaseException catch (e) {
      throw CFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw CPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  /// Lấy danh mục con

  // /// Upload danh mục giả lập (dummy data) lên Cloud Firebase
  // Future<void> uploadDummyData(List<CategoryModel> categories) async {
  //   try {
  //     // Upload tất cả danh mục kèm theo hình ảnh của chúng
  //     final storage = Get.put(CFirebaseStorageService());

  //     // Lặp qua từng danh mục
  //     for (var category in categories) {
  //       // Lấy dữ liệu hình ảnh từ assets cục bộ
  //       final file = await storage.getImageDataFromAssets(category.image);

  //       // Upload hình ảnh và lấy URL
  //       final url = await storage.uploadImageData('Categories', file, category.name);

  //       // Gán URL vào thuộc tính image của danh mục
  //       category.image = url;

  //       // Lưu danh mục vào Firestore
  //       await _db.collection("Categories").doc(category.id).set(category.toJson());
  //     }
  //   } on FirebaseException catch (e) {
  //     throw CFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const CFormatException();
  //   } on PlatformException catch (e) {
  //     throw CPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Có lỗi xảy ra. Vui lòng thử lại!';
  //   }
  // }
}
