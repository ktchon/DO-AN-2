import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/products/rating/rating_indicator.dart';
import 'package:shop_app/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:shop_app/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/constants/colors.dart';

class ProductReviewsRating extends StatelessWidget {
  const ProductReviewsRating({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        title: Text(
          'Đánh giá & Xếp hạng',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.apply(color: isDark ? Colors.white : Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Xếp hạng đánh giá
              Text(
                'Xếp hạng và đánh giá đã được xác minh và đến từ những người sử dụng cùng loại thiết bị mà bạn đang dùng.',
              ),
              SizedBox(height: 12),
              OverallProductRating(),
              CRatingBarIndicator(rating: 4.3),
              Text('12.342', style: Theme.of(context).textTheme.labelSmall),
              SizedBox(height: 32),
              // Đánh giá của người dùng
              UserReviewCard(),
              UserReviewCard(),
              UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}
