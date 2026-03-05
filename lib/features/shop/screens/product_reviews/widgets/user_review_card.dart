import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_image.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/common/widgets/products/rating/rating_indicator.dart';
import 'package:shop_app/common/widgets/text/brand_title_text.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircularImage(padding: 0, width: 45, height: 45, image: 'assets/profile/user.png'),
                SizedBox(width: 6),
                Text('Khuong Chon', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          ],
        ),
        Row(
          children: [
            CRatingBarIndicator(rating: 4.5),
            SizedBox(width: 8),
            BrandTitleText(title: '28-01-2025'),
          ],
        ),
        SizedBox(height: 12),
        Text(
          'Xếp hạng và đánh giá đã được xác minh và đến từ những người sử dụng cùng loại thiết bị mà bạn đang dùng.',
        ),
        SizedBox(height: 10),
        RoundedContainer(
          padding: EdgeInsets.all(16),
          backgroundColor: const Color.fromARGB(255, 234, 230, 230),
          borderColor: Colors.black,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BrandTitleText(title: 'Shop'),
                  BrandTitleText(title: '28-01-2025'),
                ],
              ),
              SizedBox(height: 10),
              ReadMoreText(
                style: TextStyle(color: Colors.black),
                trimCollapsedText: 'Đọc thêm',
                trimExpandedText: 'Thu gọn',
                trimLines: 2,
                trimMode: TrimMode.Line,
                moreStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                lessStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                'Đây là phần Description (mô tả) của sản phẩm trong kho hàng (In Stock), và nó có thể chứa tối đa 4 dòng. Đây là phần Description (mô tả) của sản phẩm trong kho hàng (In Stock), và nó có thể chứa tối đa 4 dòng.',
              ),
            ],
          ),
        ),
        SizedBox(height: 32),
      ],
    );
  }
}
