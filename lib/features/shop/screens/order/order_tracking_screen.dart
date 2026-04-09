import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/features/shop/controllers/order_tracking_controller.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderTrackingController());
    controller.trackOrder(orderId);
    controller.simulateShipping(orderId);

    return Scaffold(
      appBar: AppBar(title: const Text("Theo dõi đơn hàng")),
      body: Obx(() {
        final order = controller.order.value;

        if (order == null) return const Center(child: CircularProgressIndicator());

        return ListView.builder(
          itemCount: order.timeline.length,
          itemBuilder: (_, index) {
            final step = order.timeline[index];

            return ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(step.title),
              subtitle: Text(DateFormat('HH:mm dd/MM/yyyy').format(step.time)),
            );
          },
        );
      }),
    );
  }
}
