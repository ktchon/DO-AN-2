import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/data/orders/order_repository.dart';
import 'package:shop_app/features/shop/models/order_model.dart';
import 'package:shop_app/utils/constants/enums.dart';

class OrderTrackingController extends GetxController {
  final repo = OrderRepository();

  Rxn<OrderModel> order = Rxn<OrderModel>();

  void trackOrder(String orderId) {
    repo.trackOrder(orderId).listen((event) {
      order.value = event;
    });
  }

  int getCurrentStep(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.delivered:
        return 3;
      default:
        return 0;
    }
  }

  Future<void> simulateShipping(String orderId) async {
    await Future.delayed(Duration(seconds: 3));
    await repo.updateStatus(orderId, OrderStatus.confirmed);

    await Future.delayed(Duration(seconds: 3));
    await repo.updateStatus(orderId, OrderStatus.shipped);

    await Future.delayed(Duration(seconds: 3));
    await repo.updateStatus(orderId, OrderStatus.delivered);
  }

  OrderStatus mapGHNStatus(String ghnStatus) {
    switch (ghnStatus) {
      case "ready_to_pick":
      case "picking":
        return OrderStatus.confirmed;

      case "picked":
      case "transporting":
      case "sorting":
      case "delivering":
        return OrderStatus.shipped;

      case "delivered":
        return OrderStatus.delivered;

      case "cancel":
      case "return":
        return OrderStatus.cancelled;

      default:
        return OrderStatus.processing;
    }
  }

  Future<void> syncWithGHN(String orderId, String userId) async {
    final url = "https://your-cloud-function-url/syncGHNOrder";

    await http.post(
      Uri.parse(url),
      body: jsonEncode({"order_code": orderId, "userId": userId}),
      headers: {"Content-Type": "application/json"},
    );
  }
}
