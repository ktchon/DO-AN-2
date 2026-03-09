import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/features/shop/models/brand_model.dart';
import 'package:shop_app/utils/exceptions/firebase_exceptions.dart';
import 'package:shop_app/utils/exceptions/format_exceptions.dart';
import 'package:shop_app/utils/exceptions/platform_exceptions.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  /// Các biến (Variables)
  final _db = FirebaseFirestore.instance;

  /// Lấy tất cả các thương hiệu (Get all categories - Chú thích trong ảnh ghi 'categories' nhưng hàm là 'Brands')
  Future<List<BrandModel>> getAllBrands() async {
    try {
      // Lấy dữ liệu từ collection 'Brands' trong Firestore
      final snapshot = await _db.collection('Brands').get();
      // Chuyển đổi dữ liệu từ dạng tài liệu (documents) sang danh sách đối tượng BrandModel
      final result = snapshot.docs.map((e) => BrandModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      // Xử lý lỗi từ Firebase
      throw CFirebaseException(e.code).message;
    } on FormatException catch (_) {
      // Xử lý lỗi định dạng dữ liệu
      throw const CFormatException();
    } on PlatformException catch (e) {
      // Xử lý lỗi từ nền tảng (iOS/Android)
      throw CPlatformException(e.code).message;
    } catch (e) {
      // Xử lý các lỗi ngoại lệ khác
      throw 'Đã có lỗi xảy ra khi lấy dữ liệu.';
    }
  }

  /// Lấy các thương hiệu theo danh mục (Get Brands For Category)
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      // Truy vấn để lấy tất cả các tài liệu có categoryId khớp với categoryId được cung cấp
      QuerySnapshot brandCategoryQuery = await _db
          .collection('BrandCategory')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      // Trích xuất các brandId từ các tài liệu thu được
      List<String> brandIds = brandCategoryQuery.docs
          .map((doc) => doc['brandId'] as String)
          .toList();

      // Truy vấn để lấy tất cả các tài liệu mà brandId nằm trong danh sách brandIds.
      // Sử dụng FieldPath.documentId để truy vấn các tài liệu trong Bộ sưu tập (Collection)
      final brandsQuery = await _db
          .collection('Brands')
          .where(FieldPath.documentId, whereIn: brandIds)
          .limit(2)
          .get();

      // Trích xuất tên thương hiệu hoặc các dữ liệu liên quan khác từ các tài liệu
      List<BrandModel> brands = brandsQuery.docs
          .map((doc) => BrandModel.fromSnapshot(doc))
          .toList();

      return brands;
    } on FirebaseException catch (e) {
      throw CFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const CFormatException();
    } on PlatformException catch (e) {
      throw CPlatformException(e.code).message;
    } catch (e) {
      throw 'Đã xảy ra lỗi khi lấy dữ liệu';
    }
  }
}
