// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:shop_app/features/shop/controllers/coupon/coupon_controller.dart';
// import 'package:shop_app/features/shop/controllers/products/variation_controller.dart';
// import 'package:shop_app/features/shop/models/cart_item_model.dart';
// import 'package:shop_app/features/shop/models/product_model.dart';
// import 'package:shop_app/utils/constants/enums.dart';
// import 'package:shop_app/utils/popups/loaders.dart';
// import 'package:shop_app/utils/storage/storage_utility.dart';
// import 'cart_repository.dart';   // ← import repository

// class CartController extends GetxController {
//   static CartController get instance => Get.find();

//   final cartRepository = Get.put(CartRepository());

//   // Các biến reactive giữ nguyên
//   final RxInt noOfCartItems = 0.obs;
//   final RxDouble totalCartPrice = 0.0.obs;
//   final RxInt productQuantityInCart = 0.obs;
//   final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
//   final RxBool isBuyNow = false.obs;
//   final RxList<CartItemModel> buyNowItems = <CartItemModel>[].obs;

//   final VariationController variationController = VariationController.instance;
//   final couponController = CouponController.instance;

//   List<CartItemModel> get currentItems => isBuyNow.value ? buyNowItems : cartItems;

//   CartController() {
//     loadCartItems();           // load local trước
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     syncFromFirebase();        // sau đó sync từ Firebase (merge)
//   }

//   // ==================== SYNC FIREBASE ====================

//   /// Đồng bộ giỏ hàng từ Firebase xuống local (merge)
//   Future<void> syncFromFirebase() async {
//     try {
//       final cloudItems = await cartRepository.fetchAll();

//       for (var cloudItem in cloudItems) {
//         final index = cartItems.indexWhere((local) =>
//             local.productId == cloudItem.productId &&
//             local.variationId == cloudItem.variationId);

//         if (index >= 0) {
//           // Đã có local → giữ quantity local (ưu tiên UI)
//         } else {
//           cartItems.add(cloudItem);
//         }
//       }
//       updateCart();
//       saveCartItems();
//     } catch (e) {
//       CLoaders.errorSnackBar(title: 'Lỗi đồng bộ', message: e.toString());
//     }
//   }

//   /// Đồng bộ toàn bộ giỏ hàng lên Firebase (dùng sau khi thay đổi lớn)
//   Future<void> syncToFirebase() async {
//     for (var item in cartItems) {
//       await cartRepository.addOrUpdateItem(item);
//     }
//   }

//   // ==================== THAO TÁC GIỎ HÀNG ====================

//   void addToCart(ProductModel product) {
//     if (productQuantityInCart.value < 1) {
//       CLoaders.customToast(message: 'Vui lòng chọn số lượng');
//       return;
//     }

//     if (product.productType == ProductType.variable.toString() &&
//         variationController.selectedVariation.value.id.isEmpty) {
//       CLoaders.customToast(message: 'Vui lòng chọn biến thể');
//       return;
//     }

//     // Kiểm tra stock (giữ nguyên code cũ của bạn)...

//     final selectedCartItem = convertToCartItem(product, productQuantityInCart.value);

//     final index = cartItems.indexWhere((item) =>
//         item.productId == selectedCartItem.productId &&
//         item.variationId == selectedCartItem.variationId);

//     if (index >= 0) {
//       cartItems[index].quantity = selectedCartItem.quantity;
//     } else {
//       cartItems.add(selectedCartItem);
//     }

//     updateCart();

//     // Đồng bộ ngay lên Firebase
//     cartRepository.addOrUpdateItem(selectedCartItem);

//     CLoaders.customToast(message: 'Đã thêm vào giỏ hàng');
//   }

//   void addOneToCart(CartItemModel item) {
//     final index = cartItems.indexWhere((cartItem) =>
//         cartItem.productId == item.productId &&
//         cartItem.variationId == item.variationId);

//     if (index >= 0) {
//       cartItems[index].quantity += 1;
//     } else {
//       cartItems.add(item);
//     }

//     cartItems.refresh();
//     updateCart();

//     // Đồng bộ Firebase
//     cartRepository.addOrUpdateItem(item);
//   }

//   void removeOneFromCart(CartItemModel item) {
//     final index = cartItems.indexWhere((cartItem) =>
//         cartItem.productId == item.productId &&
//         cartItem.variationId == item.variationId);

//     if (index < 0) return;

//     if (cartItems[index].quantity > 1) {
//       cartItems[index].quantity -= 1;
//       cartItems.refresh();
//       updateCart();
//       cartRepository.addOrUpdateItem(cartItems[index]); // cập nhật quantity
//     } else {
//       // Số lượng = 1 → hiện dialog xóa
//       removeFromCartDialog(index);
//     }
//   }
// // 
//   void removeFromCartDialog(int index) {
//     Get.defaultDialog(
//       title: 'Xóa sản phẩm',
//       middleText: 'Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?',
//       cancel: OutlinedButton(
//         onPressed: () => Get.back(),
//         child: const Text('Huỷ'),
//       ),
//       confirm: ElevatedButton(
//         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//         onPressed: () {
//           final itemToRemove = cartItems[index];

//           // XÓA TRÊN UI + LOCAL
//           cartItems.removeAt(index);

//           // XÓA TRÊN FIREBASE NGAY LẬP TỨC
//           cartRepository.removeItem(itemToRemove);

//           updateCart();
//           CLoaders.customToast(message: 'Đã xóa sản phẩm');
//           Get.back();
//         },
//         child: const Text('Xoá'),
//       ),
//     );
//   }

//   void clearCart() {
//     cartItems.clear();
//     updateCart();
//     cartRepository.clearAll();           // xóa sạch trên Firebase
//   }

//   // Các hàm còn lại giữ nguyên: updateCartTotals, saveCartItems, loadCartItems,
//   // convertToCartItem, getProductQuantityInCart, getVariationQuantityInCart,
//   // updateAlreadyAddedProductCount, buyNow, addOrderItemsToCart...

//   void updateCart() {
//     updateCartTotals();
//     saveCartItems();
//     cartItems.refresh();
//     couponController.revalidateCoupon(currentTotalPrice);

//     // Sync toàn bộ lên Firebase (có thể debounce nếu lo lag)
//     syncToFirebase();
//   }

//   // ... (phần còn lại của class bạn copy nguyên từ code cũ)
// }