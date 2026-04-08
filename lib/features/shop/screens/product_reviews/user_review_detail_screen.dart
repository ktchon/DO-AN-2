import 'package:flutter/material.dart';
import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';
import 'package:shop_app/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:shop_app/utils/constants/colors.dart';

class UserReviewDetailScreen extends StatelessWidget {
  final String productId;
  final CartItemModel item;

  const UserReviewDetailScreen({super.key, required this.productId, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = ReviewController.instance;
    final userId = controller.authRepo.authUser?.uid;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Đánh giá của bạn',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: FutureBuilder(
        future: controller.repo.getReviews(productId),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final reviews = snapshot.data!;
          final userReview = reviews.firstWhere(
            (r) => r.userId == userId,
            orElse: () => throw Exception("Không tìm thấy"),
          );

          return Padding(
            padding: EdgeInsets.all(16),
            child: UserReviewCard(item: item, review: userReview),
          );
        },
      ),
    );
  }
}
