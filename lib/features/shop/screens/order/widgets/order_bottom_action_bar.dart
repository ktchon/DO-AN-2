import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';
import 'package:shop_app/features/shop/models/order_model.dart';
import 'package:shop_app/features/shop/screens/cart/cart.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
import 'package:shop_app/features/shop/screens/product_reviews/user_review_detail_screen.dart';
import 'package:shop_app/features/shop/screens/product_reviews/write_review.dart';

class OrderBottomActionBar extends StatelessWidget {
  const OrderBottomActionBar({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final reviewController = ReviewController.instance;

    final firstItem = order.items.first;

    /// check review (chỉ gọi 1 lần - đã có guard trong controller)
    reviewController.checkUserReviewed(firstItem.productId);

    return Obx(() {
      final isReviewed =
          reviewController.reviewedMap[firstItem.productId] ?? false;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Row(
          children: [
            /// MUA LẠI
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  cartController.addOrderItemsToCart(order.items);
                  Get.to(() => const CartItemScreen());
                },
                child: const Text("Mua lại",style: TextStyle(color: Colors.black),),
              ),
            ),

            const SizedBox(width: 10),

            /// REVIEW
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.transparent),
                  backgroundColor:
                      isReviewed ? Colors.green : Colors.redAccent,
                ),
                onPressed: () {
                  if (isReviewed) {
                    ///  Xem review
                    Get.to(() => UserReviewDetailScreen(
                          productId: firstItem.productId, item: firstItem,
                        ));
                  } else {
                    ///  Viết review
                    Get.to(() => WriteReviewScreen(item: firstItem));
                  }
                },
                child: Text(
                  isReviewed ? "Xem đánh giá" : "Viết đánh giá",
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}