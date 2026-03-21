import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  final String id; // 🆕 docId
  final String code;
  final String type; // percentage | fixed
  final double value;
  final double minOrder;
  final double? maxDiscount;
  final DateTime expiryDate;
  final int usageLimit; // 🆕
  final int usedCount; // 🆕
  final bool isActive;

  CouponModel({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    required this.minOrder,
    this.maxDiscount,
    required this.expiryDate,
    required this.usageLimit,
    required this.usedCount,
    required this.isActive,
  });

  /// 🔽 From Firestore
  factory CouponModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CouponModel(
      id: doc.id, // 🆕 lấy docId
      code: data['code'] ?? '',
      type: data['type'] ?? 'fixed',
      value: (data['value'] ?? 0).toDouble(),
      minOrder: (data['minOrder'] ?? 0).toDouble(),
      maxDiscount: data['maxDiscount'] != null ? (data['maxDiscount']).toDouble() : null,
      expiryDate: (data['expiryDate'] as Timestamp).toDate(),
      usageLimit: data['usageLimit'] ?? 0,
      usedCount: data['usedCount'] ?? 0,
      isActive: data['isActive'] ?? false,
    );
  }

  /// 🔼 Upload lên Firestore
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'type': type,
      'value': value,
      'minOrder': minOrder,
      'maxDiscount': maxDiscount,
      'expiryDate': Timestamp.fromDate(expiryDate),
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
    };
  }

  /// 🧠 Helper (rất hữu ích)
  bool get isExpired => DateTime.now().isAfter(expiryDate);

  bool canUse(double subtotal) {
    if (!isActive) return false;
    if (isExpired) return false;
    if (subtotal < minOrder) return false;
    if (usedCount >= usageLimit) return false;

    return true;
  }
}
