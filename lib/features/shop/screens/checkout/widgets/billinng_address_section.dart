import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';

class BillinngAddressSection extends StatelessWidget {
  const BillinngAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(textTitle: 'Địa chỉ giao hàng', style: true, showActionButton: false),
        SizedBox(height: 5),
        Row(children: [Icon(Iconsax.user), SizedBox(width: 8), Text('Tuyết Sương')]),
        SizedBox(height: 5),
        Row(children: [Icon(Icons.phone), SizedBox(width: 8), Text('+84 0904337370')]),
        SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.location_pin),
            SizedBox(width: 8),
            Text('Long Thạnh 2, Thốt Nốt, Cần Thơ'),
          ],
        ),
      ],
    );
  }
}
