import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/common/widgets/products/rating/product_reviews_rating.dart';
import 'package:shop_app/common/widgets/products/rating/rating_indicator.dart';
import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';
import 'package:shop_app/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:shop_app/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/constants/colors.dart';

class ProductReviewsRating extends StatefulWidget {
  const ProductReviewsRating({super.key, required this.productId});

  final String productId;

  @override
  State<ProductReviewsRating> createState() => _ProductReviewsRatingState();
}

class _ProductReviewsRatingState extends State<ProductReviewsRating> {
  final controller = ReviewController.instance;

  @override
  void initState() {
    super.initState();
    controller.fetchReviews(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Đánh giá & Xếp hạng',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.apply(color: isDark ? Colors.black : Colors.white),
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
              CRatingBarIndicator(rating: 5),
              Text('12.342', style: Theme.of(context).textTheme.labelSmall),
              SizedBox(height: 32),

              // Đánh giá của người dùng
              Obx(() {
                if (controller.isLoading.value) {
                  return CircularProgressIndicator();
                }

                if (controller.reviews.isEmpty) {
                  return Text("Chưa có đánh giá nào");
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.reviews.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final review = controller.reviews[index];
                    return UserReviewCard(review: review);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
