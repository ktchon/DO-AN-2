import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/features/shop/models/order_model.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  // Firebase instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Lấy tất cả đơn hàng của người dùng hiện tại
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;

      if (userId == null || userId.isEmpty) {
        throw 'Không tìm thấy thông tin người dùng. Vui lòng thử lại sau vài phút.';
      }

      final result = await _db.collection('Users').doc(userId).collection('Orders').get();

      // Chuyển đổi từng document thành OrderModel
      return result.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    } catch (e) {
      // Có thể log lỗi chi tiết ở đây: print(e);
      throw 'Có lỗi xảy ra khi lấy thông tin đơn hàng. Vui lòng thử lại sau.';
    }
  }

  /// Lưu đơn hàng mới cho người dùng
  Future<void> saveOrder(OrderModel order, String userId) async {
    try {
      if (userId.isEmpty) {
        throw 'User ID không hợp lệ.';
      }

      await _db.collection('Users').doc(userId).collection('Orders').add(order.toJson());
      // Nếu muốn tự set document ID thì dùng .doc(order.id).set(order.toJson());
    } catch (e) {
      // Có thể log lỗi
      throw 'Có lỗi xảy ra khi lưu đơn hàng. Vui lòng thử lại sau.';
    }
  }

  Future<void> cancelOrder({
    required String userId,
    required String orderId,
    required String reason,
  }) async {
    try {
      await _db.collection('Users').doc(userId).collection('Orders').doc(orderId).update({
        'status': 'cancelled',
        'cancelReason': reason,
        'cancelledAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Huỷ đơn thất bại");
    }
  }
}
