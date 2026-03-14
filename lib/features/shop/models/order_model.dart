import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/features/personalization/models/address_model.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart'; // nếu dùng Firestore

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
  });

  // Getter formatted date
  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate =>
      deliveryDate != null ? THelperFunctions.getFormattedDate(deliveryDate!) : '';

  // Getter trạng thái dạng text
  String get orderStatusText {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.shipped:
        return 'Shipment on the way';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Processing';
    }
  }

  // Convert to JSON (để lưu Firestore hoặc gửi API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString().split('.').last, // chỉ lấy "processing", "shipped",...
      'totalAmount': totalAmount,
      'orderDate': Timestamp.fromDate(orderDate),
      'paymentMethod': paymentMethod,
      'address': address?.toJson(),
      'deliveryDate': deliveryDate != null ? Timestamp.fromDate(deliveryDate!) : null,
      'cancelReason': cancelReason,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // Factory từ Firestore snapshot
  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
      id: snapshot.id, // id trong document
      userId: data['userId'] as String? ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (data['status'] as String? ?? 'processing'),
        orElse: () => OrderStatus.processing,
      ),
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      orderDate: (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paymentMethod: data['paymentMethod'] as String? ?? 'COD',
      cancelReason: data['cancelReason'] as String?,
      address: data['address'] != null
          ? AddressModel.fromMap(data['address'] as Map<String, dynamic>)
          : null,
      deliveryDate: data['deliveryDate'] != null
          ? (data['deliveryDate'] as Timestamp).toDate()
          : null,
      items:
          (data['items'] as List<dynamic>?)
              ?.map((itemData) => CartItemModel.fromJson(itemData as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  OrderModel copyWith({OrderStatus? status, String? cancelReason}) {
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
    );
  }
}
