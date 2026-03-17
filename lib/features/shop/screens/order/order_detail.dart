import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/features/shop/controllers/order_controller.dart';
import 'package:shop_app/features/shop/models/order_model.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/constants/enums.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Chi tiết đơn hàng',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ORDER INFO
            RoundedContainer(
              padding: const EdgeInsets.all(16),
              showBorder: true,
              backgroundColor: TColors.grey,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Iconsax.receipt_2),
                      const SizedBox(width: 10),
                      Text("Mã đơn: ${order.id}"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Iconsax.calendar),
                      const SizedBox(width: 10),
                      Text("Ngày đặt: ${order.formattedOrderDate}"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Iconsax.truck),
                      const SizedBox(width: 10),
                      Text("Ngày giao: ${order.formattedDeliveryDate}"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Iconsax.status),
                      const SizedBox(width: 10),
                      Text("Trạng thái: ${order.orderStatusText}"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// PRODUCTS LIST
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final item = order.items[index];

                return RoundedContainer(
                  padding: const EdgeInsets.all(10),
                  showBorder: true,
                  child: Row(
                    children: [
                      /// IMAGE
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(item.image ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title ?? '', style: Theme.of(context).textTheme.titleMedium),

                            const SizedBox(height: 4),

                            Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: (item.selectedVariation ?? {}).entries
                                        .map(
                                          (e) => TextSpan(
                                            children: [
                                              // Tên thuộc tính (key) - chữ nhỏ, thường
                                              TextSpan(
                                                text: '${e.key}: ',
                                                style: TextStyle(fontSize: 10, color: Colors.black),
                                              ),
                                              // Giá trị thuộc tính (value) - chữ đậm/lớn hơn
                                              TextSpan(
                                                text: '${e.value}  ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                            const SizedBox(height: 4),

                            Text(
                              "Số lượng: ${item.quantity}",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "${item.price}đ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// TOTAL
            RoundedContainer(
              padding: const EdgeInsets.all(16),
              showBorder: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tổng tiền:",
                    style: Theme.of(context).textTheme.displayMedium!.apply(color: Colors.black),
                  ),

                  Text(
                    "${order.totalAmount}đ",
                    style: Theme.of(context).textTheme.titleLarge!.apply(color: Colors.green),
                  ),
                ],
              ),
            ),
            if (order.status == OrderStatus.cancelled)
              RoundedContainer(
                padding: EdgeInsets.all(12),
                showBorder: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Đơn hàng đã bị huỷ",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 5),

                    Text("Lý do: ${order.cancelReason ?? "Không có"}"),
                  ],
                ),
              ),
            SizedBox(height: 20),
            if (order.status != OrderStatus.cancelled)
              SizedBox(
                width: 200,
                child: OutlinedButton(
                  onPressed: () => controller.showCancelDialog(context, order),
                  child: Text("Huỷ đơn hàng", style: TextStyle(color: Colors.red)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
