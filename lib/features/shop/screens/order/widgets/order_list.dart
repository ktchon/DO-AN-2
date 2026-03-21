import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/common/widgets/loaders/animation_loader.dart';
import 'package:shop_app/features/shop/controllers/order_controller.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
import 'package:shop_app/features/shop/screens/cart/cart.dart';
import 'package:shop_app/features/shop/screens/order/order_detail.dart';
import 'package:shop_app/navigation_menu.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/formatters/formatter.dart';
import 'package:shop_app/utils/helpers/cloud_helper_functions.dart';
import 'package:shop_app/utils/constants/colors.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    // final dark = THelperFunctions.isDarkMode(context);
    final cartController = CartController.instance;
    return FutureBuilder(
      future: controller.fetchUserOrders(),
      builder: (context, snapshot) {
        final emptyWidget = CAnimationLoaderWidget(
          text: 'Chưa có đơn đặt hàng nào!',
          animation: 'assets/logo/shopping-cart.json',
          showAction: true,
          actionText: "Mua sắm ngay thôi!",
          onActionPressed: () => Get.off(() => const NavigationMenu()),
        );

        /// Helper Function: Handle Loader, No Record, OR ERROR Message
        final response = CloudHelperFunctions.checkMultiRecordState(
          snapshot: snapshot,
          nothingFound: emptyWidget,
        );

        if (response != null) return response;

        final orders = snapshot.data!;
        return ListView.separated(
          itemCount: orders.length,
          shrinkWrap: true,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (_, index) {
            final order = orders[index];
            final firstItem = order.items.first;

            Color statusColor;

            switch (order.status) {
              case OrderStatus.processing:
                statusColor = Colors.orange;
                break;
              case OrderStatus.shipped:
                statusColor = Colors.blue;
                break;
              case OrderStatus.delivered:
                statusColor = Colors.green;
                break;
              case OrderStatus.pending:
                statusColor = Colors.orangeAccent;
                break;
              case OrderStatus.paid:
                statusColor = Colors.green;
                break;
              case OrderStatus.confirmed:
                statusColor = Colors.green;
                break;
              case OrderStatus.cancelled:
                statusColor = Colors.red;
                break;
            }

            return RoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(12),
              borderColor: TColors.grey,
              child: Column(
                children: [
                  /// PRODUCT ROW
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE
                      Container(
                        width: 90,
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 236, 235, 235),
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(firstItem.image ?? ''),
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
                            /// NAME
                            Text(
                              firstItem.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),

                            /// STATUS
                            Row(
                              children: [
                                Text("Trạng thái:", style: Theme.of(context).textTheme.labelLarge),
                                SizedBox(width: 2),
                                Text(
                                  order.orderStatusText,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelLarge!.apply(color: statusColor),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Số lượng: ${order.items.length}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),

                            const SizedBox(height: 6),

                            /// DELIVERY DATE
                            Text(
                              "Ngày giao: ${order.formattedDeliveryDate}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),

                            const SizedBox(height: 4),

                            Row(
                              children: [
                                Text("Tổng tiền: ", style: Theme.of(context).textTheme.labelLarge),
                                Text(
                                  "${TFormatter.formatVND(order.totalAmount)}",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelLarge!.apply(color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () => Get.to(OrderDetailScreen(order: order)),
                        icon: const Icon(Iconsax.arrow_right_3_copy),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (order.status == OrderStatus.delivered ||
                          order.status == OrderStatus.cancelled)
                        SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onPressed: () {
                              cartController.addOrderItemsToCart(order.items);
                              Get.to(() => const CartItemScreen());
                            },
                            child: const Text("Mua lại", style: TextStyle(fontSize: 12)),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
