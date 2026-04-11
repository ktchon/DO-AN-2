import 'dart:async';
import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlng;
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
  Timer? timer;

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
          "order_code": order.ghnCode,
          "userId": order.userId,
          "orderId": order.id,
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

  void startTracking(String orderCode, String userId, String orderId) {
    // Nếu order chưa có ghnCode thật (test case) thì vẫn fake được
    final effectiveCode = (orderCode == null || orderCode.isEmpty) ? "fake-${orderId}" : orderCode;

    fetchTracking(effectiveCode, userId, orderId);

    timer = Timer.periodic(const Duration(seconds: 15), (_) {
      fetchTracking(effectiveCode, userId, orderId); // dùng effectiveCode
      fakeMoveAlongRoute();
    });
  }

  Future<void> fetchTracking(String orderCode, String userId, String orderId) async {
    try {
      final res = await http.post(
        Uri.parse("https://syncghnorder-6fdwcwqf4a-uc.a.run.app"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "order_code": orderCode, // giờ luôn có giá trị
          "userId": userId,
          "orderId": orderId,
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data["success"] == true) {
          ghnStatus.value = data["ghnStatus"] ?? "";
          if (data["timeline"] != null) {
            timeline.value = data["timeline"]; // (dù UI chưa dùng nhưng giữ nguyên)
          }
        }
      } else {
        print("❌ GHN sync lỗi: ${res.statusCode} ${res.body}");
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

  final List<latlng.LatLng> routePoints = [
    latlng.LatLng(10.7769, 106.7009), // TP.HCM
    latlng.LatLng(10.6500, 106.5500), // Gần Long An
    latlng.LatLng(10.4000, 106.3000), // Gần Mỹ Tho
    latlng.LatLng(10.2000, 106.0000), // Gần Vĩnh Long
    latlng.LatLng(10.0333, 105.7833), // Cần Thơ
  ];

  int currentRouteIndex = 0;

  void fakeMoveAlongRoute() {
    if (currentRouteIndex < routePoints.length - 1) {
      currentRouteIndex++;
    } else {
      currentRouteIndex = routePoints.length - 1;
    }

    lat.value = routePoints[currentRouteIndex].latitude;
    lng.value = routePoints[currentRouteIndex].longitude;
  }
}
