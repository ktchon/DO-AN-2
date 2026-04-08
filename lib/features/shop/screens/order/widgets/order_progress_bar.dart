import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shop_app/features/shop/controllers/order_tracking_controller.dart';
import 'package:shop_app/utils/constants/enums.dart';

class OrderProgressBar extends StatelessWidget {
  final OrderStatus status;

  const OrderProgressBar({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderTrackingController>();
    final steps = ["Đã đặt hàng", "Đã xác nhận", "Đang giao hàng", "Hoàn tất"];
    final currentStep = controller.getCurrentStep(status);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final slotWidth = totalWidth / steps.length;
        final halfSlot = slotWidth / 2;

        return Column(
          children: [
            SizedBox(
              height: 24,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: halfSlot,
                    right: halfSlot,
                    child: Row(
                      children: List.generate(steps.length - 1, (i) {
                        final isActive = i < currentStep;
                        return Expanded(
                          child: Container(height: 3, color: isActive ? Colors.green : Colors.grey),
                        );
                      }),
                    ),
                  ),
                  // Circles
                  Row(
                    children: List.generate(steps.length, (i) {
                      final isActive = i <= currentStep;
                      return Expanded(
                        child: Center(
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: isActive ? Colors.green : Colors.grey,
                            child: const Icon(Icons.check, size: 14, color: Colors.white),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Row(
              children: List.generate(steps.length, (i) {
                final isActive = i <= currentStep;
                return Expanded(
                  child: Text(
                    steps[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: isActive ? Colors.green : Colors.grey,
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
