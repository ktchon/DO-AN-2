import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/features/shop/models/share_product_model.dart';
import 'package:shop_app/features/shop/screens/product-details/widgets/product_attributes.dart';
import 'package:shop_app/features/shop/screens/product-details/widgets/product_detail_image_slide.dart';
import 'package:shop_app/features/shop/screens/product-details/widgets/product_meta_data.dart';
import 'package:shop_app/features/shop/screens/product-details/widgets/rating_and_share.dart';
import 'package:shop_app/features/shop/screens/product_reviews/product_reviews_rating.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 120,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircularContainer(
                    width: 25,
                    height: 25,
                    onPressed: () => controller.productQuantityInCart.value < 1
                        ? null
                        : controller.productQuantityInCart.value -= 1,
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.all(0),
                    child: Icon(Icons.remove),
                  ),
                  SizedBox(width: 6),
                  Text(
                    controller.productQuantityInCart.value.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 6),
                  CircularContainer(
                    width: 25,
                    height: 25,
                    onPressed: () => controller.productQuantityInCart.value += 1,
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.all(0),
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color.fromARGB(255, 244, 252, 245)),
                    child: SizedBox(
                      width: 30,
                      child: IconButton(
                        onPressed: controller.productQuantityInCart.value < 1
                            ? null
                            : () => controller.addToCart(product),
                        icon: Icon(Icons.add_shopping_cart, size: 30, color: TColors.buttonPrimary),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {},
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
                  // Nút mua, bình luận, mô tả chi tiết.
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () {}, child: Text('Mua ngay')),
                  ),
                  SizedBox(height: 20),
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
                    product.description ?? '',
                  ),
                  // Bình luận
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionHeading(
                        textTitle: 'Bình luận (199)',
                        showActionButton: false,
                        textColor: THelperFunctions.isDarkMode(context)
                            ? Colors.white
                            : Colors.black,
                      ),
                      IconButton(
                        onPressed: () => Get.to(ProductReviewsRating()),
                        icon: Icon(Iconsax.arrow_right_3_copy),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
