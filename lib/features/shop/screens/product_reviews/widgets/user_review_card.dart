import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_image.dart';
import 'package:shop_app/common/widgets/products/rating/rating_indicator.dart';
import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';
import 'package:shop_app/features/shop/models/reviews/reviews_model.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key, required this.review});
  final ReviewModel review;

  void _showReportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (_) {
        String selectedReason = "";
        final TextEditingController otherController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Báo cáo bình luận", style: TextStyle(fontSize: 18, color: Colors.red)),
                  Divider(),
                  ListTile(
                    title: Text("Spam"),
                    leading: Radio(
                      value: "Spam",
                      groupValue: selectedReason,
                      onChanged: (value) => setState(() => selectedReason = value!),
                    ),
                  ),
                  ListTile(
                    title: Text("Nội dung không phù hợp"),
                    leading: Radio(
                      value: "Inappropriate",
                      groupValue: selectedReason,
                      onChanged: (value) => setState(() => selectedReason = value!),
                    ),
                  ),
                  ListTile(
                    title: Text("Lừa đảo"),
                    leading: Radio(
                      value: "Scam",
                      groupValue: selectedReason,
                      onChanged: (value) => setState(() => selectedReason = value!),
                    ),
                  ),
                  ListTile(
                    title: Text("Khác"),
                    leading: Radio(
                      value: "Other",
                      groupValue: selectedReason,
                      onChanged: (value) => setState(() => selectedReason = value!),
                    ),
                  ),

                  if (selectedReason == "Other")
                    TextField(
                      controller: otherController,
                      decoration: InputDecoration(hintText: "Nhập lý do..."),
                    ),

                  SizedBox(height: 10),

                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Gửi báo cáo"),
                    ),
                  ),
                ],
              ),
            );
          },
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
            IconButton(
              onPressed: () => _showReportBottomSheet(context),
              icon: Icon(Icons.more_vert),
            ),
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
            children: review.images.map((img) {
              return _buildImage(img);
            }).toList(),
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

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl.trim(),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image);
        },
      ),
    );
  }
}
