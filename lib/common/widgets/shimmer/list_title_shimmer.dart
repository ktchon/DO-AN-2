import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';

class CListTileShimmer extends StatelessWidget {
  const CListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            CShimmerEffect(width: 50, height: 50, radius: 50),
            SizedBox(width: 20),
            Column(
              children: [
                CShimmerEffect(width: 100, height: 15),
                SizedBox(height: 10),
                CShimmerEffect(width: 80, height: 12),
              ],
            ), // Column
          ],
        ), // Row
      ],
    ); // Column
  }
}
