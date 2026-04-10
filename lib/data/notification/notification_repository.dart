import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/features/shop/models/notification/notification_model.dart';

class NotificationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'Notifications';

  // ─────────────────────────────────────────────────────────────
  // STREAMS
  // ─────────────────────────────────────────────────────────────

  /// Lắng nghe realtime toàn bộ notifications của user
  Stream<List<AppNotification>> watchUserNotifications(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppNotification.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Lắng nghe số lượng notification chưa đọc (dùng cho badge)
  Stream<int> watchUnreadCount(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  // ─────────────────────────────────────────────────────────────
  // QUERIES
  // ─────────────────────────────────────────────────────────────

  /// Lấy notifications theo type (phân trang)
  Future<List<AppNotification>> getByType({
    required String userId,
    required String type,
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    Query query = _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: type)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => AppNotification.fromMap(
            doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // ─────────────────────────────────────────────────────────────
  // WRITE OPERATIONS
  // ─────────────────────────────────────────────────────────────

  /// Tạo notification mới
  Future<void> createNotification(AppNotification notification) async {
    await _db.collection(_collection).add(notification.toMap());
  }

  /// Tạo nhiều notifications cùng lúc (dùng cho broadcast promo)
  Future<void> createBulkNotifications(
      List<AppNotification> notifications) async {
    final batch = _db.batch();
    for (final noti in notifications) {
      final ref = _db.collection(_collection).doc();
      batch.set(ref, noti.toMap());
    }
    await batch.commit();
  }

  /// Đánh dấu 1 notification đã đọc
  Future<void> markAsRead(String notificationId) async {
    await _db
        .collection(_collection)
        .doc(notificationId)
        .update({'isRead': true});
  }

  /// Đánh dấu tất cả đã đọc
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

  /// Xóa 1 notification
  Future<void> deleteNotification(String notificationId) async {
    await _db.collection(_collection).doc(notificationId).delete();
  }

  /// Xóa tất cả notifications của user
  Future<void> deleteAllForUser(String userId) async {
    final snapshot = await _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    final batch = _db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ─────────────────────────────────────────────────────────────
  // FCM TOKEN MANAGEMENT
  // ─────────────────────────────────────────────────────────────

  /// Lưu FCM token vào Users collection
  Future<void> saveFCMToken(String userId, String token) async {
    await _db.collection('Users').doc(userId).update({
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Xóa FCM token (khi logout)
  Future<void> removeFCMToken(String userId) async {
    await _db.collection('Users').doc(userId).update({
      'fcmToken': FieldValue.delete(),
    });
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS (tạo notification từ các collection hiện có)
  // ─────────────────────────────────────────────────────────────

  /// Tạo notification đơn hàng từ Order data
  Future<void> createOrderNotification({
    required String userId,
    required String orderId,
    required String subtype,
    required String title,
    required String body,
    String? image,
  }) async {
    final noti = AppNotification(
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
    );
    await createNotification(noti);
  }

  /// Tạo notification khuyến mãi từ Coupons/Banners
  Future<void> createPromoNotification({
    required String userId,
    required String title,
    required String body,
    String? image,
    String? couponId,
    String? bannerId,
  }) async {
    final noti = AppNotification(
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
    );
    await createNotification(noti);
  }

  /// Tạo notification cá nhân hóa từ SearchHistory + Products
  Future<void> createPersonalNotification({
    required String userId,
    required String productId,
    required String title,
    required String body,
    String? productImage,
  }) async {
    final noti = AppNotification(
      id: '',
      userId: userId,
      type: NotificationType.personal,
      title: title,
      body: body,
      image: productImage,
      isRead: false,
      createdAt: DateTime.now(),
      data: {'productId': productId},
    );
    await createNotification(noti);
  }

  /// Tạo notification đánh giá từ Reviews
  Future<void> createReviewNotification({
    required String userId,
    required String reviewId,
    required String productId,
    required String title,
    required String body,
  }) async {
    final noti = AppNotification(
      id: '',
      userId: userId,
      type: NotificationType.review,
      title: title,
      body: body,
      isRead: false,
      createdAt: DateTime.now(),
      data: {'reviewId': reviewId, 'productId': productId},
    );
    await createNotification(noti);
  }

  /// Tạo notification chat
  Future<void> createChatNotification({
    required String userId,
    required String chatId,
    required String senderName,
    required String message,
    String? senderAvatar,
  }) async {
    final noti = AppNotification(
      id: '',
      userId: userId,
      type: NotificationType.chat,
      title: senderName,
      body: message,
      image: senderAvatar,
      isRead: false,
      createdAt: DateTime.now(),
      data: {'chatId': chatId},
    );
    await createNotification(noti);
  }
}