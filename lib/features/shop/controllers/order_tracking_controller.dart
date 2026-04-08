import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
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
}
