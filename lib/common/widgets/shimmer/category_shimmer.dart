import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';

class CCategoryShimmer extends StatelessWidget {
  const CCategoryShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Hình ảnh shimmer (placeholder cho ảnh danh mục)
              CShimmerEffect(width: 55, height: 55, radius: 55),

              SizedBox(height: 8),

              /// Văn bản shimmer (placeholder cho tên danh mục)
              CShimmerEffect(width: 55, height: 8),
            ],
          );
        },
      ),
    );
  }
}
