import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';

class CBrandsShimmer extends StatelessWidget {
  const CBrandsShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridLayout(
      mainAxisExtent: 80,
      itemCount: itemCount,
      itemBuilder: (_, __) => const CShimmerEffect(width: 300, height: 80),
    );
  }
}
