import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';

class CHorizontalProductShimmer extends StatelessWidget {
  const CHorizontalProductShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      height: 129, // hoặc 120 tùy phiên bản bạn muốn
      child: ListView.separated(
        itemCount: itemCount,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (_, __) => const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // /// Image + Shimmer
            CShimmerEffect(width: 120, height: 120),
            SizedBox(width: 20),

            // /// Text phần bên phải (tiêu đề + mô tả + giá...)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),

                // Dòng 1: Tiêu đề sản phẩm
                CShimmerEffect(width: 160, height: 15),

                SizedBox(height: 10),

                // Dòng 2: Mô tả hoặc thương hiệu
                CShimmerEffect(width: 110, height: 15),

                SizedBox(height: 10),

                // Dòng 3: Giá tiền hoặc rating
                CShimmerEffect(width: 80, height: 15),

                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
