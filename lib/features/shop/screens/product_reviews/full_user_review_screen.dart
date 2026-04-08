import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';
import 'package:shop_app/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:shop_app/utils/constants/colors.dart';

class UserAllReviewDetailScreen extends StatefulWidget {
  const UserAllReviewDetailScreen({super.key});

  @override
  State<UserAllReviewDetailScreen> createState() => _UserReviewDetailScreenState();
}

class _UserReviewDetailScreenState extends State<UserAllReviewDetailScreen> {
  final controller = ReviewController.instance;

  @override
  void initState() {
    super.initState();

    /// LOAD REVIEW USER
    controller.fetchUserReviews().then((_) {
      /// đồng bộ với reviews để reuse logic cũ
      controller.reviews.assignAll(controller.userReviews);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Tất cả đánh giá',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),

      body: Obx(() {
        if (controller.userReviews.isEmpty) {
          return Center(child: Text("Bạn chưa có đánh giá nào"));
        }

        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: controller.userReviews.length,
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemBuilder: (_, index) {
            final review = controller.userReviews[index];

            return UserReviewCard(review: review, item: CartItemModel.empty());
          },
        );
      }),
    );
  }
}
