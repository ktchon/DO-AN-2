import 'dart:async';
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
  RxList timeline = [].obs;
  RxString ghnStatus = "".obs;
  RxDouble lat = 10.0333.obs;
  RxDouble lng = 105.7833.obs;

  void fakeMove() {
    lat.value += 0.001;
    lng.value += 0.001;
  }

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

  Future<void> syncWithGHN(OrderModel order) async {
    if (order.ghnCode == null) return;

    final url = "https://syncghnorder-6fdwcwqf4a-uc.a.run.app";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "order_code": order.ghnCode, // "LHQNMV"
          "userId": order.userId, // "lbbUb2KlVtOTGkdohFoSgZbacth1"
          "orderId": order.id, // "[#534f2]"
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print("✅ GHN sync thành công: ${response.body}");
      } else {
        print("❌ GHN sync lỗi: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("❌ GHN sync exception: $e");
    }
  }

  Timer? timer;

  void startTracking(String orderCode, String userId, String orderId) {
    fetchTracking(orderCode, userId, orderId);

    timer = Timer.periodic(Duration(seconds: 5), (_) {
      fetchTracking(orderCode, userId, orderId);
      fakeMove();
    });
  }

  Future<void> fetchTracking(String orderCode, String userId, String orderId) async {
    try {
      final res = await http.post(
        Uri.parse("https://syncghnorder-6fdwcwqf4a-uc.a.run.app"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"order_code": orderCode, "userId": userId, "orderId": orderId}),
      );

      final data = jsonDecode(res.body);

      if (data["success"] == true) {
        ghnStatus.value = data["ghnStatus"];

        if (data["timeline"] != null) {
          timeline.value = data["timeline"];
        }
      }
    } catch (e) {
      print("Tracking error: $e");
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
