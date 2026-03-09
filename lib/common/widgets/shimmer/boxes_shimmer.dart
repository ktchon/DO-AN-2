import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';

class CBoxesShimmer extends StatelessWidget {
  const CBoxesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: CShimmerEffect(width: 150, height: 110)),
            SizedBox(width: 20),
            Expanded(child: CShimmerEffect(width: 150, height: 110)),
            SizedBox(width: 20),
            Expanded(child: CShimmerEffect(width: 150, height: 110)),
          ],
        ), // Row
      ],
    ); // Column
  }
}
