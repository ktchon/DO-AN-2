import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/features/personalization/models/address_model.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';
import 'package:shop_app/features/shop/models/order_timeline/order_timeline_model.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? address;
  final DateTime? deliveryDate;
  final String? cancelReason;
  final List<CartItemModel> items;
  final String paymentNote;
  final DateTime? expireAt;
  final String? couponId;
  final List<OrderTimeline> timeline;

  OrderModel({
    required this.id,
    this.userId = '',
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'COD',
    this.address,
    this.deliveryDate,
    required this.items,
    this.cancelReason,
    required this.paymentNote,
    this.expireAt,
    this.couponId,
    this.timeline = const [], // ✅ default tránh null crash
  });

  /// ================= GETTERS =================

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate =>
      deliveryDate != null ? THelperFunctions.getFormattedDate(deliveryDate!) : '';

  String get orderStatusText {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.shipped:
        return 'Shipment on the way';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.confirmed:
        return 'Confirmed';
      default:
        return 'Processing';
    }
  }

  /// ================= TO JSON =================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.name,
      'totalAmount': totalAmount,
      'orderDate': Timestamp.fromDate(orderDate),
      'paymentMethod': paymentMethod,
      'paymentNote': paymentNote,
      'address': address?.toJson(),
      'deliveryDate': deliveryDate != null ? Timestamp.fromDate(deliveryDate!) : null,
      'cancelReason': cancelReason,
      'items': items.map((item) => item.toJson()).toList(),
      'expireAt': expireAt != null ? Timestamp.fromDate(expireAt!) : null,
      'couponId': couponId,

      ///  ADD TIMELINE
      'timeline': timeline.map((e) => e.toJson()).toList(),
    };
  }

  /// ================= FROM FIRESTORE =================

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
      id: snapshot.id,
      userId: data['userId'] ?? '',

      status: OrderStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'processing'),
        orElse: () => OrderStatus.processing,
      ),

      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,

      orderDate: (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),

      paymentMethod: data['paymentMethod'] ?? 'COD',

      paymentNote: data['paymentNote'] ?? '', // ✅ tránh null crash

      cancelReason: data['cancelReason'],

      address: data['address'] != null ? AddressModel.fromMap(data['address']) : null,

      deliveryDate: data['deliveryDate'] != null
          ? (data['deliveryDate'] as Timestamp).toDate()
          : null,

      items:
          (data['items'] as List<dynamic>?)?.map((e) => CartItemModel.fromJson(e)).toList() ?? [],

      expireAt: data['expireAt'] != null ? (data['expireAt'] as Timestamp).toDate() : null,

      couponId: data['couponId'],

      /// ✅ PARSE TIMELINE
      timeline:
          (data['timeline'] as List<dynamic>?)?.map((e) => OrderTimeline.fromMap(e)).toList() ?? [],
    );
  }

  /// ================= COPY WITH =================

  OrderModel copyWith({
    OrderStatus? status,
    String? cancelReason,
    DateTime? expireAt,
    List<OrderTimeline>? timeline,
  }) {
    return OrderModel(
      id: id,
      userId: userId,
      status: status ?? this.status,
      totalAmount: totalAmount,
      orderDate: orderDate,
      paymentMethod: paymentMethod,
      address: address,
      deliveryDate: deliveryDate,
      cancelReason: cancelReason ?? this.cancelReason,
      items: items,
      paymentNote: paymentNote,
      expireAt: expireAt ?? this.expireAt,
      couponId: couponId,
      timeline: timeline ?? this.timeline,
    );
  }
}
