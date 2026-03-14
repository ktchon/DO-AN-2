import 'package:flutter/material.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/helpers/pricing_calculator.dart';

class BillingAmountSection extends StatelessWidget {
  const BillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final subTotal = cartController.totalCartPrice.value;
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
              '${subTotal}',
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
              '${CPricingCalculator.calculateShippingCost(subTotal, 'Hồ Chí Minh')}',
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
              '${CPricingCalculator.calculateTax(subTotal, 'VN')}',
              style: Theme.of(context).textTheme.labelMedium!.apply(
                color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
              ),
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
              '580.000đ',
              style: Theme.of(context).textTheme.titleMedium!.apply(
                color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
