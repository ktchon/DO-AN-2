import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';

class BillingPaymentSection extends StatelessWidget {
  const BillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(
          textTitle: 'Phương thức thanh toán',
          style: true,
          buttonTitle: 'Thay đổi',
          onPressed: () {},
        ),
        Row(
          children: [
            RoundedContainer(
              padding: EdgeInsets.all(10),
              width: 50,
              height: 50,
              child: Image(image: AssetImage('assets/logo/logo-paypal.png'), fit: BoxFit.contain),
            ),
            SizedBox(width: 10),
            Text('Paypal', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}
