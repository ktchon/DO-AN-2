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
}
