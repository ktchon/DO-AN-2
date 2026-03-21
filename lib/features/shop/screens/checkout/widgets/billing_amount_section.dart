import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
import 'package:shop_app/utils/formatters/formatter.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/helpers/pricing_calculator.dart';

class BillingAmountSection extends StatelessWidget {
  const BillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final couponController = Get.put(CouponController());
    return Obx(() {
      final subTotal = cartController.totalCartPrice.value;
      final shipping = CPricingCalculator.calculateShippingCost(subTotal, "Hồ Chí Minh");
      final tax = CPricingCalculator.calculateTax(subTotal, 'VN');
      final discount = couponController.discount.value;
      final totalAmount = subTotal + shipping + tax - discount;
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tạm tính
              Text(
                'Tạm tính',
                style: Theme.of(context).textTheme.bodyLarge!.apply(
                  color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                ),
              ),
              Text(
                TFormatter.formatVND(subTotal),
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Phí vận chuyển
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phí vận chuyển',
                style: Theme.of(context).textTheme.bodyLarge!.apply(
                  color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                ),
              ),
              Text(
                TFormatter.formatVND(shipping),
                style: Theme.of(context).textTheme.labelMedium!.apply(
                  color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Thuế
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thuế',
                style: Theme.of(context).textTheme.bodyLarge!.apply(
                  color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                ),
              ),
              Text(
                TFormatter.formatVND(tax),
                style: Theme.of(context).textTheme.labelMedium!.apply(
                  color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          if (discount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Giảm giá',
                  style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.green),
                ),
                Text(
                  '-${TFormatter.formatVND(discount)}',
                  style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.green),
                ),
              ],
            ),
          SizedBox(height: 8),
          // Tổng tiền
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng tiền',
                style: Theme.of(context).textTheme.titleMedium!.apply(
                  color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                ),
              ),
              Text(
                TFormatter.formatVND(totalAmount),
                style: Theme.of(context).textTheme.titleMedium!.apply(
                  color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.redAccent,
                ),
              ),
            ],
          ),
          Divider(),
        ],
      );
    });
  }
}
