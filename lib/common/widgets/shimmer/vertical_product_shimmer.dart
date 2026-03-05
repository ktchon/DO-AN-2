import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';

class CVerticalProductShimmer extends StatelessWidget {
  const CVerticalProductShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) => const SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image
            CShimmerEffect(width: 180, height: 180),
            SizedBox(height: 12),

            /// Text
            CShimmerEffect(width: 160, height: 15),
            SizedBox(height: 6),
            CShimmerEffect(width: 110, height: 15),
          ],
        ),
      ),
    );
  }
}
