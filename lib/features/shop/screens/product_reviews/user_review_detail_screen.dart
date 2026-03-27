import 'package:flutter/material.dart';
import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';
import 'package:shop_app/features/shop/screens/product_reviews/widgets/user_review_card.dart';

class UserReviewDetailScreen extends StatelessWidget {
  final String productId;

  const UserReviewDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = ReviewController.instance;
    final userId = controller.authRepo.authUser?.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Đánh giá của bạn")),
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
            child: UserReviewCard(review: userReview),
          );
        },
      ),
    );
  }
}
