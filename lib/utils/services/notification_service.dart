import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shop_app/features/shop/screens/order/order.dart';
import 'package:shop_app/navigation_menu.dart';

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
    importance: Importance.defaultImportance,
  );
  static const _chatChannel = AndroidNotificationChannel(
    'chat_channel',
    'Tin nhắn',
    importance: Importance.high,
    playSound: true,
  );
  static const _generalChannel = AndroidNotificationChannel(
    'general_channel',
    'Thông báo chung',
    importance: Importance.defaultImportance,
  );

  Future<void> init() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

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
        _handlePayload(response.payload ?? '');
      },
    );

    final androidPlugin = _localPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_orderChannel);
    await androidPlugin?.createNotificationChannel(_promoChannel);
    await androidPlugin?.createNotificationChannel(_chatChannel);
    await androidPlugin?.createNotificationChannel(_generalChannel);

    _listenForeground();
    _listenBackground();
    await _handleTerminated();
  }

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });
  }

  void _listenBackground() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _navigateFromData(message.data);
    });
  }

  Future<void> _handleTerminated() async {
    final message = await _fcm.getInitialMessage();
    if (message != null) {
      await Future.delayed(const Duration(seconds: 2));
      _navigateFromData(message.data);
    }
  }

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
      payload: message.data.entries.map((e) => '${e.key}=${e.value}').join('|'),
    );
  }

  void _handlePayload(String payload) {
    if (payload.isEmpty) return;
    final Map<String, dynamic> data = {};
    for (final part in payload.split('|')) {
      final kv = part.split('=');
      if (kv.length == 2) data[kv[0]] = kv[1];
    }
    _navigateFromData(data);
  }

  /// Navigation trực tiếp — không dùng named routes
  void _navigateFromData(Map<String, dynamic> data) {
    final type = data['type'];
    switch (type) {
      case 'order':
      case 'review':
        // Mở OrderScreen — tự load đơn hàng của user
        Get.to(() => OrderScreen());
        break;
      case 'promo':
      case 'personal':
      case 'chat':
      default:
        // Về trang chủ (NavigationMenu)
        Get.offAll(() => NavigationMenu());
        break;
    }
  }

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
