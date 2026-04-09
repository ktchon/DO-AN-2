import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/features/shop/controllers/order_tracking_controller.dart';
import 'package:shop_app/utils/constants/colors.dart';

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

    /// ⏱ delay để đảm bảo có order rồi mới start tracking
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
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              /// MAP
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 200,
                  child: Obx(
                    () => GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(controller.lat.value, controller.lng.value),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("order"),
                          position: LatLng(controller.lat.value, controller.lng.value),
                        ),
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              /// TIMELINE
              Expanded(
                child: ListView.builder(
                  itemCount: order.timeline.length,
                  itemBuilder: (_, index) {
                    final step = order.timeline[index];

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// LINE + DOT
                        Column(
                          children: [
                            const Icon(Icons.circle, size: 12, color: Colors.green),
                            if (index != order.timeline.length - 1)
                              Container(width: 2, height: 50, color: Colors.grey),
                          ],
                        ),

                        const SizedBox(width: 10),

                        /// TEXT
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
