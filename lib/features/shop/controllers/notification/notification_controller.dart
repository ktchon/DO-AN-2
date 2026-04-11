import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shop_app/data/notification/notification_repository.dart';
import 'package:shop_app/features/shop/models/notification/notification_model.dart';
import 'package:shop_app/features/shop/screens/order/order.dart';
import 'package:shop_app/navigation_menu.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  final NotificationRepository _repo = NotificationRepository();

  // ── OBSERVABLES ──────────────────────────────────────────────
  final RxList<AppNotification> _allNotifications = <AppNotification>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = true.obs;
  final RxString selectedTab = 'all'.obs;
  final RxBool isDeleting = false.obs;
  final RxSet<String> selectedIds = <String>{}.obs;
  final RxBool isSelectMode = false.obs;

  StreamSubscription? _notificationStream;
  StreamSubscription? _unreadStream;

  // ── GETTERS ──────────────────────────────────────────────────
  List<AppNotification> get filteredNotifications {
    if (selectedTab.value == 'all') return _allNotifications;
    return _allNotifications.where((n) => n.type.value == selectedTab.value).toList();
  }

  bool get hasUnread => unreadCount.value > 0;

  // ── LIFECYCLE ────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _startListening();
  }

  @override
  void onClose() {
    _notificationStream?.cancel();
    _unreadStream?.cancel();
    super.onClose();
  }

  // ── STREAM ───────────────────────────────────────────────────
  void _startListening() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      isLoading.value = false;
      return;
    }

    // Stream notifications
    _notificationStream = _repo
        .watchUserNotifications(userId)
        .listen(
          (list) {
            _allNotifications.assignAll(list);
            isLoading.value = false;
          },
          onError: (e) {
            print('[NotificationController] Error: $e');
            isLoading.value = false;
          },
        );

    // Stream unread count (badge)
    _unreadStream = _repo.watchUnreadCount(userId).listen((count) {
      unreadCount.value = count;
    });
  }

  // ── ACTIONS ──────────────────────────────────────────────────
  void changeTab(String tab) {
    selectedTab.value = tab;
    exitSelectMode();
  }

  Future<void> markAsRead(String id) async {
    await _repo.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    await _repo.markAllAsRead(userId);
    Get.snackbar('✅', 'Đã đánh dấu tất cả là đã đọc', snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> deleteNotification(String id) async {
    await _repo.deleteNotification(id);
  }

  Future<void> deleteAll() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    isDeleting.value = true;
    await _repo.deleteAllForUser(userId);
    isDeleting.value = false;
    Get.snackbar('🗑️', 'Đã xóa tất cả thông báo', snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> deleteSelected() async {
    if (selectedIds.isEmpty) return;
    isDeleting.value = true;
    for (final id in List<String>.from(selectedIds)) {
      await _repo.deleteNotification(id);
    }
    isDeleting.value = false;
    exitSelectMode();
  }

  // ── SELECT MODE ───────────────────────────────────────────────
  void enterSelectMode() => isSelectMode.value = true;
  void exitSelectMode() {
    isSelectMode.value = false;
    selectedIds.clear();
  }

  void toggleSelect(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void selectAll() {
    selectedIds.addAll(filteredNotifications.map((n) => n.id));
  }

  // ── NAVIGATION KHI TAP (không dùng named routes) ─────────────
  void handleNotificationTap(AppNotification noti) {
    if (!noti.isRead) markAsRead(noti.id);

    switch (noti.type) {
      case NotificationType.order:
        // Mở màn hình đơn hàng — không cần truyền orderId vì OrderScreen
        // sẽ tự load danh sách đơn hàng của user
        Get.to(() => OrderScreen());
        break;

      case NotificationType.promo:
        // Chuyển về trang chủ (có banner/coupon)
        Get.offAll(() => NavigationMenu());
        break;

      case NotificationType.personal:
        // Chuyển về trang chủ hoặc store
        Get.offAll(() => NavigationMenu());
        break;

      case NotificationType.review:
        // Mở màn hình đơn hàng để user đánh giá
        Get.to(() => OrderScreen());
        break;

      case NotificationType.chat:
        // Chưa có chat screen → về trang chủ
        Get.offAll(() => NavigationMenu());
        break;

      case NotificationType.system:
        Get.offAll(() => NavigationMenu());
        break;
    }
  }

  // ── HELPER ───────────────────────────────────────────────────
  String getTimeAgo(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
