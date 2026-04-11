import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/features/shop/models/notification/notification_model.dart';

class NotificationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'Notifications';

  // ─────────────────────────────────────────────────────────────
  // STREAMS
  // ─────────────────────────────────────────────────────────────

  /// Stream realtime — có fallback khi index chưa build xong
  Stream<List<AppNotification>> watchUserNotifications(String userId) {
    // Query có orderBy → cần index
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .handleError((error) {
          // Index chưa build → fallback query không orderBy
          print('[NotificationRepo] Index not ready, using fallback: $error');
        })
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => AppNotification.fromMap(doc.data(), doc.id))
              .toList();
          // Sort ở client khi index chưa sẵn sàng
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  /// Stream unread count (badge)
  Stream<int> watchUnreadCount(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .handleError((error) {
          print('[NotificationRepo] watchUnreadCount error: $error');
        })
        .map((snapshot) => snapshot.size);
  }

  // ─────────────────────────────────────────────────────────────
  // WRITE OPERATIONS
  // ─────────────────────────────────────────────────────────────

  Future<void> createNotification(AppNotification notification) async {
    await _db.collection(_collection).add(notification.toMap());
  }

  Future<void> createBulkNotifications(List<AppNotification> notifications) async {
    final batch = _db.batch();
    for (final noti in notifications) {
      final ref = _db.collection(_collection).doc();
      batch.set(ref, noti.toMap());
    }
    await batch.commit();
  }

  Future<void> markAsRead(String notificationId) async {
    await _db.collection(_collection).doc(notificationId).update({'isRead': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final snapshot = await _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _db.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  /// Xóa 1 notification — trả về Future để UI có thể await
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _db.collection(_collection).doc(notificationId).delete();
      print('[NotificationRepo] Deleted: $notificationId');
    } catch (e) {
      print('[NotificationRepo] Delete error: $e');
      rethrow;
    }
  }

  Future<void> deleteAllForUser(String userId) async {
    // Lấy theo batch 500 docs (Firestore limit)
    QuerySnapshot snapshot;
    do {
      snapshot = await _db
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .limit(500)
          .get();

      if (snapshot.docs.isEmpty) break;

      final batch = _db.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } while (snapshot.docs.length == 500);
  }

  // ─────────────────────────────────────────────────────────────
  // FCM TOKEN
  // ─────────────────────────────────────────────────────────────

  Future<void> saveFCMToken(String userId, String token) async {
    await _db.collection('Users').doc(userId).update({
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFCMToken(String userId) async {
    await _db.collection('Users').doc(userId).update({'fcmToken': FieldValue.delete()});
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────

  Future<void> createOrderNotification({
    required String userId,
    required String orderId,
    required String subtype,
    required String title,
    required String body,
    String? image,
  }) async {
    await createNotification(
      AppNotification(
        id: '',
        userId: userId,
        type: NotificationType.order,
        subtype: subtype,
        title: title,
        body: body,
        image: image,
        isRead: false,
        createdAt: DateTime.now(),
        data: {'orderId': orderId},
      ),
    );
  }

  Future<void> createPromoNotification({
    required String userId,
    required String title,
    required String body,
    String? image,
    String? couponId,
    String? bannerId,
  }) async {
    await createNotification(
      AppNotification(
        id: '',
        userId: userId,
        type: NotificationType.promo,
        title: title,
        body: body,
        image: image,
        isRead: false,
        createdAt: DateTime.now(),
        data: {
          if (couponId != null) 'couponId': couponId,
          if (bannerId != null) 'bannerId': bannerId,
        },
      ),
    );
  }

  Future<void> createPersonalNotification({
    required String userId,
    required String productId,
    required String title,
    required String body,
    String? productImage,
  }) async {
    await createNotification(
      AppNotification(
        id: '',
        userId: userId,
        type: NotificationType.personal,
        title: title,
        body: body,
        image: productImage,
        isRead: false,
        createdAt: DateTime.now(),
        data: {'productId': productId},
      ),
    );
  }

  Future<void> createReviewNotification({
    required String userId,
    required String reviewId,
    required String productId,
    required String title,
    required String body,
  }) async {
    await createNotification(
      AppNotification(
        id: '',
        userId: userId,
        type: NotificationType.review,
        title: title,
        body: body,
        isRead: false,
        createdAt: DateTime.now(),
        data: {'reviewId': reviewId, 'productId': productId},
      ),
    );
  }

  Future<void> createChatNotification({
    required String userId,
    required String chatId,
    required String senderName,
    required String message,
    String? senderAvatar,
  }) async {
    await createNotification(
      AppNotification(
        id: '',
        userId: userId,
        type: NotificationType.chat,
        title: senderName,
        body: message,
        image: senderAvatar,
        isRead: false,
        createdAt: DateTime.now(),
        data: {'chatId': chatId},
      ),
    );
  }
}
