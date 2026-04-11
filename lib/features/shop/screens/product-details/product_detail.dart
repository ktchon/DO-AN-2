import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:shop_app/common/widgets/icons/cart_counter_icon.dart';
import 'package:shop_app/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/features/shop/models/share_product_model.dart';
import 'package:shop_app/features/shop/screens/cart/cart.dart';
import 'package:shop_app/features/shop/screens/checkout/checkout.dart';
import 'package:shop_app/features/shop/screens/product-details/widgets/product_attributes.dart';
import 'package:shop_app/features/shop/screens/product-details/widgets/product_detail_image_slide.dart';
import 'package:shop_app/features/shop/screens/product-details/widgets/product_meta_data.dart';
import 'package:shop_app/features/shop/screens/product-details/widgets/rating_and_share.dart';
import 'package:shop_app/features/shop/screens/product_reviews/product_reviews_rating.dart';
import 'package:shop_app/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    final reviewController = ReviewController.instance;
    reviewController.fetchReviews(product.id);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Chi tiết sản phẩm',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
        actions: [
          CartCounterIcon(colorCart: true, onPressed: () => Get.to(() => CartItemScreen())),
          CFavouriteIcon(productId: product.id),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 120,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: TColors.grey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    CircularContainer(
                      radius: 6,
                      width: 28,
                      height: 28,
                      onPressed: () => controller.productQuantityInCart.value < 1
                          ? null
                          : controller.productQuantityInCart.value -= 1,
                      backgroundColor: TColors.grey,
                      padding: EdgeInsets.all(0),
                      child: Icon(Icons.remove),
                    ),
                    SizedBox(width: 10),
                    Text(
                      controller.productQuantityInCart.value.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    CircularContainer(
                      radius: 6,
                      width: 28,
                      height: 28,
                      onPressed: () => controller.productQuantityInCart.value += 1,
                      backgroundColor: TColors.grey,
                      padding: EdgeInsets.all(0),
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color.fromARGB(255, 244, 252, 245),
                    ),
                    child: SizedBox(
                      width: 30,
                      child: IconButton(
                        onPressed: () => controller.addToCart(product),
                        icon: Icon(Icons.add_shopping_cart, size: 30, color: TColors.buttonPrimary),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        final cartController = CartController.instance;

                        cartController.buyNow(product);

                        if (cartController.buyNowItems.isNotEmpty) {
                          Get.to(() => const CheckoutScreen());
                        }
                      },
                      child: Text('Mua ngay', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Ảnh chính và ảnh phụ
            ProductImageSilder(product: product),
            Padding(
              padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: Column(
                children: [
                  // Đánh giá và chia sẻ
                  RatingAndShare(
                    product: ShareProductModel(
                      id: product.id,
                      title: product.title,
                      price: product.price,
                      salePrice: product.salePrice,
                      imageUrl: product.thumbnail,
                      productUrl: "https://shopapp.com/product/${product.id}",
                    ),
                  ),
                  // Giá, giảm giá, tên, trạng thái, thương hiệu
                  ProductMetaData(product: product),
                  // Các thuộc tính
                  if (product.productType == ProductType.variable.toString())
                    ProductAttributes(product: product),
                  if (product.productType == ProductType.variable.toString()) SizedBox(height: 20),
                  // Bình luận, mô tả chi tiết.
                  SizedBox(height: 10),
                  SectionHeading(
                    textTitle: 'Mô tả sản phẩm',
                    showActionButton: false,
                    textColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                  ),
                  SizedBox(height: 10),
                  // Mô tả chi tiết
                  ReadMoreText(
                    style: TextStyle(color: Colors.black),
                    trimCollapsedText: 'Đọc thêm',
                    trimExpandedText: 'Thu gọn',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    moreStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    lessStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    product.description,
                  ),
                  // Bình luận
                  Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        final totalReview = reviewController.totalReviews;
                        return SectionHeading(
                          textTitle: 'Đánh giá ($totalReview)',
                          showActionButton: false,
                          textColor: THelperFunctions.isDarkMode(context)
                              ? Colors.white
                              : Colors.black,
                        );
                      }),

                      Row(
                        children: [
                          Text('Xem thêm'),
                          IconButton(
                            onPressed: () =>
                                Get.to(() => ProductReviewsRating(productId: product.id)),
                            icon: Icon(Iconsax.arrow_right_3_copy, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  FutureBuilder(
                    future: reviewController.fetchLatestReviews(product.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();

                      final reviews = snapshot.data!;

                      if (reviews.isEmpty) {
                        return Text("Chưa có đánh giá");
                      }

                      return Column(
                        children: reviews.map((review) {
                          return UserReviewCard(review: review, item: CartItemModel.empty());
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
