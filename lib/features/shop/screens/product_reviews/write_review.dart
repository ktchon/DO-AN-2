import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/common/widgets/products/rating/product_reviews_rating.dart';

import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';
import 'package:shop_app/features/shop/models/reviews/reviews_model.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/formatters/formatter.dart';

class WriteReviewScreen extends StatelessWidget {
  const WriteReviewScreen({super.key, required this.item, this.review});
  final CartItemModel item;
  final ReviewModel? review;
  @override
  Widget build(BuildContext context) {
    final controller = ReviewController.instance;
    final TextEditingController commentController = TextEditingController(
      text: controller.comment.value,
    );
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Viết đánh giá',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sản phẩm
            if (item.image != null && item.image!.isNotEmpty)
              Row(
                children: [
                  Container(
                    width: 90,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 236, 235, 235),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(item.image ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TÊN
                        Text(
                          item.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),

                        SizedBox(height: 4),

                        /// GIÁ
                        Text(
                          TFormatter.formatVND(item.price),
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
                        ),

                        SizedBox(height: 4),

                        /// SIZE + COLOR (VARIATION)
                        if (item.selectedVariation != null && item.selectedVariation!.isNotEmpty)
                          Text.rich(
                            TextSpan(
                              children: item.selectedVariation!.entries.map((e) {
                                return TextSpan(
                                  children: [
                                    /// KEY (Màu, Size)
                                    TextSpan(
                                      text: '${e.key}: ',
                                      style: TextStyle(fontSize: 11, color: Colors.grey),
                                    ),

                                    /// VALUE (Đen, M)
                                    TextSpan(
                                      text: '${e.value}  ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),
            // Rating stars
            Center(
              child: Obx(
                () => CRatingBar(
                  rating: controller.rating.value,
                  itemSize: 40,
                  onRatingUpdate: (value) {
                    controller.rating.value = value;
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Chấm điểm đơn hàng
            Center(
              child: const Text(
                'Chấm điểm đơn hàng của bạn*',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 32),

            // Chia sẻ suy nghĩ
            const Text(
              'Chia sẻ suy nghĩ của bạn',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            const SizedBox(height: 20),

            // TextField
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (value) => controller.comment.value = value,
                controller: commentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Chia sẻ đánh giá của bạn về sản phẩm...',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Align(
              alignment: Alignment.centerRight,
              child: Text('0/300', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),

            const SizedBox(height: 24),

            // Thêm ảnh hoặc video
            const Text(
              'Thêm ảnh hoặc video',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final controller = ReviewController.instance;

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  /// ===== ẢNH CŨ =====
                  for (int i = 0; i < controller.existingImages.length; i++)
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.openFullScreen(context, controller.existingImages, i);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              controller.existingImages[i],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// NÚT XOÁ
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              controller.existingImages.removeAt(i);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),

                  /// ===== ẢNH MỚI =====
                  for (int i = 0; i < controller.selectedImages.length; i++)
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.openFullScreenFiles(context, controller.selectedImages, i);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(controller.selectedImages[i].path),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              controller.removeImage(i);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            }),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => controller.pickImages(),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Thêm ảnh hoặc video', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Đăng ẩn danh
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    value: controller.isAnonymous.value,
                    onChanged: (value) => controller.isAnonymous.value = value!,
                  ),
                ),
                const Text('Đăng ẩn danh'),
              ],
            ),

            const SizedBox(height: 30),

            // Nút Gửi
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () => controller.submitReview(item: item),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: controller.isSubmitting.value
                    ? CircularProgressIndicator()
                    : Text('Gửi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
