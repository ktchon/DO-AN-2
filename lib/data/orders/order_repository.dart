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

  // SAVE ORDER
  Future<void> saveOrder(OrderModel order, String userId) async {
    if (userId.isEmpty) {
      throw Exception('User ID không hợp lệ');
    }

    await _db.runTransaction((transaction) async {
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

        final productType = productData['ProductType'] ?? 'ProductType.single';

        // =====================================
        // 🧠 CASE 1: PRODUCT SINGLE
        // =====================================
        if (productType == 'ProductType.single') {
          final currentStock = (productData['Stock'] as num?)?.toInt() ?? 0;

          if (currentStock < item.quantity) {
            throw Exception(
              'Sản phẩm hết hàng: ${item.productId} (còn $currentStock, cần ${item.quantity})',
            );
          }

          transaction.update(productRef, {
            'Stock': FieldValue.increment(-item.quantity),
            'Sold': FieldValue.increment(item.quantity),
          });
        } else {
          // =====================================
          // 🧠 CASE 2: PRODUCT VARIATION
          // =====================================
          if (item.variationId == null || item.variationId!.isEmpty) {
            throw Exception('Thiếu variationId cho sản phẩm: ${item.productId}');
          }

          final variations = List<Map<String, dynamic>>.from(
            productData['ProductVariations'] ?? [],
          );

          final index = variations.indexWhere((v) => v['Id'] == item.variationId);

          if (index == -1) {
            throw Exception('Biến thể không tồn tại: ${item.variationId}');
          }

          final variation = variations[index];
          final currentStock = (variation['Stock'] as num?)?.toInt() ?? 0;

          if (currentStock < item.quantity) {
            throw Exception(
              'Biến thể hết hàng: ${item.variationId} (còn $currentStock, cần ${item.quantity})',
            );
          }

          variations[index] = {
            ...variation,
            'Stock': currentStock - item.quantity,
            'Sold': (variation['Sold'] as num? ?? 0).toInt() + item.quantity,
          };

          transaction.update(productRef, {
            'ProductVariations': variations,
            'Sold': FieldValue.increment(item.quantity),
          });
        }
      }

      // ================================
      // 🧾 SAVE ORDER
      // ================================
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
              'Stock': FieldValue.increment(quantity),
              'Sold': FieldValue.increment(-quantity),
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
