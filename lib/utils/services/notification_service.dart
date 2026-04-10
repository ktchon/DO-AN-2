import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

// Top-level background handler — BẮT BUỘC phải là top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('[FCM Background] ${message.notification?.title}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localPlugin = FlutterLocalNotificationsPlugin();

  // Android channels
  static const _orderChannel = AndroidNotificationChannel(
    'order_channel',
    'Đơn hàng',
    description: 'Thông báo trạng thái đơn hàng',
    importance: Importance.high,
    playSound: true,
  );
  static const _promoChannel = AndroidNotificationChannel(
    'promo_channel',
    'Khuyến mãi',
    description: 'Flash sale và voucher',
    importance: Importance.defaultImportance,
  );
  static const _chatChannel = AndroidNotificationChannel(
    'chat_channel',
    'Tin nhắn',
    description: 'Tin nhắn từ shop',
    importance: Importance.high,
    playSound: true,
  );
  static const _generalChannel = AndroidNotificationChannel(
    'general_channel',
    'Thông báo chung',
    description: 'Đánh giá, cá nhân hóa',
    importance: Importance.defaultImportance,
  );

  // ── INIT ─────────────────────────────────────────────────────
  Future<void> init() async {
    // 1. Xin quyền
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // 2. Khởi tạo local notifications
    await _localPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        // Click notification khi app foreground
        _handlePayload(response.payload ?? '');
      },
    );

    // 3. Tạo Android channels
    final androidPlugin = _localPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_orderChannel);
    await androidPlugin?.createNotificationChannel(_promoChannel);
    await androidPlugin?.createNotificationChannel(_chatChannel);
    await androidPlugin?.createNotificationChannel(_generalChannel);

    // 4. Lắng nghe các trạng thái
    _listenForeground();
    _listenBackground();
    await _handleTerminated();
  }

  // ── FOREGROUND: app đang mở → hiện local notification ────────
  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((message) {
      print('[FCM Foreground] ${message.notification?.title}');
      _showLocalNotification(message);
    });
  }

  // ── BACKGROUND: app ở nền, user tap notification ─────────────
  void _listenBackground() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('[FCM Tap from background] ${message.data}');
      _navigateFromData(message.data);
    });
  }

  // ── TERMINATED: app bị tắt hoàn toàn, user tap notification ──
  Future<void> _handleTerminated() async {
    final message = await _fcm.getInitialMessage();
    if (message != null) {
      print('[FCM Tap from terminated] ${message.data}');
      // Delay để app load xong
      await Future.delayed(const Duration(seconds: 2));
      _navigateFromData(message.data);
    }
  }

  // ── HIỆN LOCAL NOTIFICATION (khi app foreground) ─────────────
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final type = message.data['type'] ?? 'general';

    await _localPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _getChannelId(type),
          _getChannelName(type),
          importance: (type == 'order' || type == 'chat')
              ? Importance.high
              : Importance.defaultImportance,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      // Encode data để dùng khi user tap
      payload: message.data.entries.map((e) => '${e.key}=${e.value}').join('|'),
    );
  }

  // ── DECODE PAYLOAD & NAVIGATE ─────────────────────────────────
  void _handlePayload(String payload) {
    if (payload.isEmpty) return;
    final Map<String, dynamic> data = {};
    for (final part in payload.split('|')) {
      final kv = part.split('=');
      if (kv.length == 2) data[kv[0]] = kv[1];
    }
    _navigateFromData(data);
  }

  void _navigateFromData(Map<String, dynamic> data) {
    final type = data['type'];
    switch (type) {
      case 'order':
        Get.toNamed('/order-detail', arguments: data['orderId']);
        break;
      case 'promo':
        data['couponId'] != null
            ? Get.toNamed('/coupons', arguments: data['couponId'])
            : Get.toNamed('/store');
        break;
      case 'personal':
        if (data['productId'] != null) {
          Get.toNamed('/product-detail', arguments: data['productId']);
        }
        break;
      case 'review':
        if (data['productId'] != null) {
          Get.toNamed('/product-detail', arguments: data['productId']);
        }
        break;
      case 'chat':
        if (data['chatId'] != null) {
          Get.toNamed('/chat', arguments: data['chatId']);
        }
        break;
      default:
        // Mở tab thông báo trong NavigationMenu
        Get.offAllNamed('/navigation', arguments: {'tab': 3});
        break;
    }
  }

  // ── HELPERS ───────────────────────────────────────────────────
  String _getChannelId(String type) {
    switch (type) {
      case 'order':
        return _orderChannel.id;
      case 'promo':
        return _promoChannel.id;
      case 'chat':
        return _chatChannel.id;
      default:
        return _generalChannel.id;
    }
  }

  String _getChannelName(String type) {
    switch (type) {
      case 'order':
        return _orderChannel.name;
      case 'promo':
        return _promoChannel.name;
      case 'chat':
        return _chatChannel.name;
      default:
        return _generalChannel.name;
    }
  }

  Future<String?> getToken() async => await _fcm.getToken();
}
