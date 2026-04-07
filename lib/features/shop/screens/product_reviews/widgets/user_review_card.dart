import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_image.dart';
import 'package:shop_app/common/widgets/products/rating/rating_indicator.dart';
import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';
import 'package:shop_app/features/shop/models/reviews/reviews_model.dart';
import 'package:shop_app/features/shop/screens/product_reviews/widgets/report_review_bottom_sheet.dart';
import 'package:shop_app/features/shop/screens/product_reviews/write_review.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class UserReviewCard extends StatelessWidget {
  UserReviewCard({super.key, required this.review, required this.item});
  final ReviewModel review;
  final CartItemModel item;
  final controller = ReviewController.instance;
  void _showOptions(BuildContext context) {
    final isOwner = controller.isMyReview(review.userId);

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              /// ===== OWNER =====
              if (isOwner) ...[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Chỉnh sửa"),
                  onTap: () {
                    Navigator.pop(context);

                    controller.setEditingReview(review);
                    Get.to(() => WriteReviewScreen(review: review, item: item));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text("Xoá"),
                  onTap: () {
                    Navigator.pop(context);

                    Get.defaultDialog(
                      title: "Xác nhận",
                      middleText: "Bạn có chắc muốn xoá?",
                      onConfirm: () {
                        controller.deleteReview(review.id, review.productId);
                        Get.back();
                      },
                      onCancel: () {},
                    );
                  },
                ),
              ]
              /// ===== USER KHÁC =====
              else ...[
                ListTile(
                  leading: const Icon(Icons.flag, color: Colors.orange),
                  title: const Text("Báo cáo"),
                  onTap: () {
                    Navigator.pop(context);

                    ReportReviewBottomSheet.show(context, (reason) {
                      controller.reportReview(reviewId: review.id, reason: reason);
                    });
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircularImage(padding: 0, width: 45, height: 45, image: 'assets/profile/user.png'),
                SizedBox(width: 6),
                Text(review.userName),
              ],
            ),

            /// MENU 3 CHẤM
            IconButton(onPressed: () => _showOptions(context), icon: Icon(Icons.more_vert)),
          ],
        ),

        /// Rating + date
        Row(
          children: [
            CRatingBarIndicator(rating: review.rating),
            SizedBox(width: 8),
            Text(THelperFunctions.getFormattedDate(review.createdAt)),
          ],
        ),

        SizedBox(height: 10),

        Text(review.comment),

        SizedBox(height: 10),

        /// ẢNH REVIEW
        if (review.images.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(review.images.length, (index) {
              final img = review.images[index];
              return _buildImage(context, img, review.images, index);
            }),
          ),

        SizedBox(height: 10),

        /// LIKE
        Obx(() {
          final controller = ReviewController.instance;

          final updatedReview = controller.reviews.firstWhere(
            (r) => r.id == review.id,
            orElse: () => review,
          );

          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("${updatedReview.likes}"),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () => controller.like(review.id),
                child: Icon(
                  updatedReview.isLiked == true ? Iconsax.like_1 : Iconsax.like_1_copy,
                  color: updatedReview.isLiked == true ? Colors.blueGrey : Colors.grey,
                ),
              ),
            ],
          );
        }),
        SizedBox(height: 10),
        const Divider(),
      ],
    );
  }

  Widget _buildImage(BuildContext context, String imageUrl, List<String> images, int index) {
    return GestureDetector(
      onTap: () => controller.openFullScreen(context, images, index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl.trim(),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image);
          },
        ),
      ),
    );
  }
}
