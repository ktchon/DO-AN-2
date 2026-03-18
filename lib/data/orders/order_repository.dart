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

  Future<void> saveOrder(OrderModel order, String userId) async {
    if (userId.isEmpty) {
      throw Exception('User ID không hợp lệ');
    }

    await _db.runTransaction((transaction) async {
      // 1. Kiểm tra và trừ tồn kho cho từng sản phẩm trong order
      for (final item in order.items) {
        final productRef = _db.collection('Products').doc(item.productId);
        final productSnap = await transaction.get(productRef);

        if (!productSnap.exists) {
          throw Exception('Sản phẩm không tồn tại: ${item.productId}');
        }

        final productData = productSnap.data();
        if (productData == null) {
          throw Exception('Dữ liệu sản phẩm bị lỗi: ${item.productId}');
        }

        if (item.variationId == null || item.variationId!.isEmpty) {
          // ── CASE 1: Sản phẩm thường (không có biến thể)
          final currentStock = (productData['stock'] as num?)?.toInt() ?? 0;

          if (currentStock < item.quantity) {
            throw Exception(
              'Sản phẩm hết hàng: ${item.productId} (còn $currentStock, cần ${item.quantity})',
            );
          }

          transaction.update(productRef, {
            'stock': FieldValue.increment(-item.quantity),
            'sold': FieldValue.increment(item.quantity),
          });
        } else {
          // ── CASE 2: Sản phẩm có biến thể
          final variations = (productData['ProductVariations'] as List<dynamic>?) ?? [];

          final variation = variations.firstWhere(
            (v) => v['Id'] == item.variationId,
            orElse: () => null,
          );

          if (variation == null) {
            throw Exception('Biến thể không tồn tại: ${item.variationId}');
          }

          final currentStock = (variation['Stock'] as num?)?.toInt() ?? 0;

          if (currentStock < item.quantity) {
            throw Exception(
              'Biến thể hết hàng: ${item.variationId} (còn $currentStock, cần ${item.quantity})',
            );
          }

          // Tạo mảng variations đã cập nhật
          final updatedVariations = variations.map((v) {
            if (v['Id'] == item.variationId) {
              return {
                ...v,
                'Stock': (v['Stock'] as num? ?? 0).toInt() - item.quantity,
                'Sold': (v['Sold'] as num? ?? 0).toInt() + item.quantity,
              };
            }
            return v;
          }).toList();

          transaction.update(productRef, {'ProductVariations': updatedVariations});
        }
      }

      // 2. Lưu đơn hàng vào sub-collection của user
      final orderRef = _db.collection('Users').doc(userId).collection('Orders').doc(order.id);

      transaction.set(orderRef, {
        ...order.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
    });
  }

  Future<void> cancelOrder({
    required String userId,
    required String orderId,
    required String reason,
  }) async {
    try {
      await _db.runTransaction((transaction) async {
        /// 🔥 1. Lấy order
        final orderRef = _db.collection('Users').doc(userId).collection('Orders').doc(orderId);

        final orderSnap = await transaction.get(orderRef);

        if (!orderSnap.exists) {
          throw Exception("Đơn hàng không tồn tại");
        }

        final orderData = orderSnap.data();
        if (orderData == null) {
          throw Exception("Dữ liệu đơn hàng lỗi");
        }

        /// tránh huỷ 2 lần
        if (orderData['status'] == 'cancelled') {
          throw Exception("Đơn đã được huỷ trước đó");
        }

        final List items = orderData['items'] ?? [];

        /// HOÀN LẠI STOCK
        for (final item in items) {
          final productId = item['productId'];
          final variationId = item['variationId'];
          final quantity = item['quantity'];

          final productRef = _db.collection('Products').doc(productId);
          final productSnap = await transaction.get(productRef);

          if (!productSnap.exists) continue;

          final productData = productSnap.data();
          if (productData == null) continue;

          /// ===== PRODUCT THƯỜNG =====
          if (variationId == null || variationId == '') {
            transaction.update(productRef, {
              'stock': FieldValue.increment(quantity),
              'sold': FieldValue.increment(-quantity),
            });
          }
          /// ===== VARIATION (ARRAY) =====
          else {
            final List variations = (productData['ProductVariations'] ?? []) as List;

            final updatedVariations = variations.map((v) {
              if (v['Id'] == variationId) {
                return {
                  ...v,
                  'Stock': (v['Stock'] ?? 0) + quantity,
                  'Sold': (v['Sold'] ?? 0) - quantity,
                };
              }
              return v;
            }).toList();

            transaction.update(productRef, {'ProductVariations': updatedVariations});
          }
        }

        /// 🔥 3. UPDATE ORDER
        transaction.update(orderRef, {
          'status': 'cancelled',
          'cancelReason': reason,
          'cancelledAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw Exception("Huỷ đơn thất bại: $e");
    }
  }
}
