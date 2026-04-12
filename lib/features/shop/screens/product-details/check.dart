// @override
// Widget build(BuildContext context) {
//   final cartController = CartController.instance;
//   final reviewController = ReviewController.instance;

//   // Khởi tạo RecommendationController
//   final recommendationController = Get.put(RecommendationController());

//   // Load dữ liệu gợi ý
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     recommendationController.loadRecommendationsForProduct(product);
//   });

//   // Fetch reviews
//   reviewController.fetchReviews(product.id);

//   return Scaffold(
//     appBar: AppBar(
//       iconTheme: const IconThemeData(color: Colors.white),
//       title: Text(
//         'Chi tiết sản phẩm',
//         style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
//       ),
//       backgroundColor: TColors.primary,
//       actions: [
//         CartCounterIcon(colorCart: true, onPressed: () => Get.to(() => const CartItemScreen())),
//         CFavouriteIcon(productId: product.id),
//       ],
//     ),
//     bottomNavigationBar: Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       height: 120,
//       child: Obx(
//         () => Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Quantity
//             Container(
//               decoration: BoxDecoration(
//                 color: TColors.grey,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Row(
//                 children: [
//                   CircularContainer(
//                     radius: 6,
//                     width: 28,
//                     height: 28,
//                     onPressed: () => cartController.productQuantityInCart.value < 1
//                         ? null
//                         : cartController.productQuantityInCart.value -= 1,
//                     backgroundColor: TColors.grey,
//                     padding: EdgeInsets.zero,
//                     child: const Icon(Icons.remove),
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     cartController.productQuantityInCart.value.toString(),
//                     style: const TextStyle(fontSize: 16, color: Colors.black),
//                   ),
//                   const SizedBox(width: 10),
//                   CircularContainer(
//                     radius: 6,
//                     width: 28,
//                     height: 28,
//                     onPressed: () => cartController.productQuantityInCart.value += 1,
//                     backgroundColor: TColors.grey,
//                     padding: EdgeInsets.zero,
//                     child: const Icon(Icons.add),
//                   ),
//                 ],
//               ),
//             ),

//             // Buttons
//             Row(
//               children: [
//                 Container(
//                   width: 60,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     color: const Color.fromARGB(255, 244, 252, 245),
//                   ),
//                   child: IconButton(
//                     onPressed: () => cartController.addToCart(product),
//                     icon: const Icon(Icons.add_shopping_cart, size: 30, color: TColors.buttonPrimary),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 SizedBox(
//                   width: 160,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       cartController.buyNow(product);
//                       if (cartController.buyNowItems.isNotEmpty) {
//                         Get.to(() => const CheckoutScreen());
//                       }
//                     },
//                     child: const Text('Mua ngay', style: TextStyle(fontSize: 13)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//     body: SingleChildScrollView(
//       child: Column(
//         children: [
//           ProductImageSilder(product: product),

//           Padding(
//             padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 RatingAndShare(
//                   product: ShareProductModel(
//                     id: product.id,
//                     title: product.title,
//                     price: product.price,
//                     salePrice: product.salePrice,
//                     imageUrl: product.thumbnail,
//                     productUrl: "https://shopapp.com/product/${product.id}",
//                   ),
//                 ),
//                 ProductMetaData(product: product),

//                 if (product.productType == ProductType.variable.toString())
//                   ProductAttributes(product: product),

//                 const SizedBox(height: 20),

//                 SectionHeading(
//                   textTitle: 'Mô tả sản phẩm',
//                   showActionButton: false,
//                   textColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
//                 ),
//                 const SizedBox(height: 10),

//                 ReadMoreText(
//                   product.description ?? '',
//                   trimCollapsedText: 'Đọc thêm',
//                   trimExpandedText: 'Thu gọn',
//                   trimLines: 2,
//                   trimMode: TrimMode.Line,
//                   moreStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
//                   lessStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
//                 ),

//                 const Divider(),
//                 const SizedBox(height: 10),

//                 // Reviews
//                 Obx(() {
//                   final totalReview = reviewController.totalReviews;
//                   return SectionHeading(
//                     textTitle: 'Đánh giá ($totalReview)',
//                     showActionButton: false,
//                     textColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
//                   );
//                 }),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Xem thêm'),
//                     IconButton(
//                       onPressed: () => Get.to(() => ProductReviewsRating(productId: product.id)),
//                       icon: const Icon(Iconsax.arrow_right_3_copy, size: 20),
//                     ),
//                   ],
//                 ),

//                 FutureBuilder(
//                   future: reviewController.fetchLatestReviews(product.id),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) return const CircularProgressIndicator();
//                     final reviews = snapshot.data!;
//                     if (reviews.isEmpty) return const Text("Chưa có đánh giá");
//                     return Column(
//                       children: reviews.map((review) => UserReviewCard(review: review, item: CartItemModel.empty())).toList(),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 30),

//           // ==================== GỢI Ý SẢN PHẨM ====================
//           // SẢN PHẨM TƯƠNG TỰ
//           Obx(() => SimilarProductsSection(
//                 products: recommendationController.similarProducts,
//               )),

//           const SizedBox(height: 24),

//           // SẢN PHẨM THƯỜNG MUA KÈM
//           Obx(() => ComplementaryProductsSection(
//                 products: recommendationController.complementaryProducts,
//               )),

//           const SizedBox(height: 40),
//         ],
//       ),
//     ),
//   );
// }