import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  order,
  promo,
  personal,
  review,
  chat,
  system,
}

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.order:
        return 'order';
      case NotificationType.promo:
        return 'promo';
      case NotificationType.personal:
        return 'personal';
      case NotificationType.review:
        return 'review';
      case NotificationType.chat:
        return 'chat';
      case NotificationType.system:
        return 'system';
    }
  }

  static NotificationType fromString(String value) {
    switch (value) {
      case 'order':
        return NotificationType.order;
      case 'promo':
        return NotificationType.promo;
      case 'personal':
        return NotificationType.personal;
      case 'review':
        return NotificationType.review;
      case 'chat':
        return NotificationType.chat;
      default:
        return NotificationType.system;
    }
  }
}

enum OrderNotificationSubtype {
  placed,       // Đặt hàng thành công
  confirmed,    // Đã xác nhận
  packed,       // Đã đóng gói
  shipping,     // Đang giao hàng
  delivered,    // Giao thành công
  failed,       // Giao thất bại
  returned,     // Hoàn trả
  refunded,     // Hoàn tiền
}

class AppNotification {
  final String id;
  final String userId;
  final NotificationType type;
  final String? subtype;
  final String title;
  final String body;
  final String? image;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    this.subtype,
    required this.title,
    required this.body,
    this.image,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  factory AppNotification.fromMap(Map<String, dynamic> json, String id) {
    return AppNotification(
      id: id,
      userId: json['userId'] ?? '',
      type: NotificationTypeExtension.fromString(json['type'] ?? 'system'),
      subtype: json['subtype'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      image: json['image'],
      isRead: json['isRead'] ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type.value,
      'subtype': subtype,
      'title': title,
      'body': body,
      'image': image,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
      'data': data,
    };
  }

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      userId: userId,
      type: type,
      subtype: subtype,
      title: title,
      body: body,
      image: image,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      data: data,
    );
  }
}