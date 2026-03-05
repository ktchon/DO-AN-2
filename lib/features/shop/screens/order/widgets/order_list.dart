import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/constants/colors.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return ListView.separated(
      itemCount: 6,
      shrinkWrap: true,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (_, index) => RoundedContainer(
        showBorder: true,
        padding: EdgeInsets.all(10),
        backgroundColor: dark ? TColors.dark : TColors.grey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Iconsax.ship_copy),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Đang xử lý",
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.apply(color: Colors.deepPurpleAccent),
                      ),
                      Text("29-01-2025", style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Iconsax.arrow_right_3_copy)),
              ],
            ),
            SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Iconsax.receipt_2_copy),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Đơn hàng", style: Theme.of(context).textTheme.labelSmall),
                            Text("[#DH001]", style: Theme.of(context).textTheme.labelLarge),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Iconsax.calendar_edit_copy),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Ngày dự kiến giao",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Text("01-2-2025", style: Theme.of(context).textTheme.labelLarge),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
