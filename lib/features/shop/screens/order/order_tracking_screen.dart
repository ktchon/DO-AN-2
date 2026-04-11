import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/features/shop/controllers/order_tracking_controller.dart';
import 'package:shop_app/utils/constants/colors.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final controller = Get.put(OrderTrackingController());

  @override
  void initState() {
    super.initState();

    controller.trackOrder(widget.orderId);

    Future.delayed(const Duration(milliseconds: 500), () {
      final order = controller.order.value;
      if (order != null) {
        controller.startTracking(order.ghnCode ?? "", order.userId ?? "", order.id ?? "");
      }
    });
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Theo dõi đơn hàng',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: Obx(() {
        final order = controller.order.value;

        if (order == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// MAP
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 280, // tăng nhẹ cho dễ nhìn
                  child: Obx(
                    () => FlutterMap(
                      options: MapOptions(
                        initialCenter: latlng.LatLng(controller.lat.value, controller.lng.value),
                        initialZoom: 11.0, // giảm zoom một chút để thấy rõ route
                      ),
                      children: [
                        // TileLayer ĐÃ SỬA (chuẩn OSM - load tốt hơn ở VN)
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                          userAgentPackageName: 'com.example.shop_app',
                        ),

                        // Marker
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: latlng.LatLng(controller.lat.value, controller.lng.value),
                              child: const Icon(Icons.location_on, color: Colors.red, size: 45),
                              width: 45,
                              height: 45,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// TIMELINE
              Expanded(
                child: ListView.builder(
                  itemCount: order.timeline.length,
                  itemBuilder: (_, index) {
                    final step = order.timeline[index];

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.circle, size: 12, color: Colors.green),
                            if (index != order.timeline.length - 1)
                              Container(width: 2, height: 50, color: Colors.grey),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('HH:mm dd/MM/yyyy').format(step.time),
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
