import 'package:flutter/material.dart';
import 'package:shop_app/features/shop/screens/order/widgets/order_list.dart';
import 'package:shop_app/utils/constants/colors.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Xem lại đơn hàng',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: Padding(padding: EdgeInsets.all(20), child: OrderListItem()),
    );
  }
}
