import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/features/shop/controllers/products/variation_controller.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/popups/loaders.dart';
import 'package:shop_app/utils/storage/storage_utility.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  // Các biến observable (reactive) để UI tự động cập nhật
  final RxInt noOfCartItems = 0.obs; // Tổng số sản phẩm trong giỏ (tổng quantity)
  final RxDouble totalCartPrice = 0.0.obs; // Tổng tiền giỏ hàng
  final RxInt productQuantityInCart =
      0.obs; // Số lượng tạm chọn cho sản phẩm hiện tại (trước khi add)
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs; // Danh sách các item trong giỏ

  final VariationController variationController = VariationController.instance;

  CartController() {
    loadCartItems();
  }

  /// Thêm sản phẩm vào giỏ hàng
  void addToCart(ProductModel product) {
    // Kiểm tra số lượng đã chọn
    if (productQuantityInCart.value < 1) {
      CLoaders.customToast(message: 'Vui lòng chọn số lượng');
      return;
    }

    // Kiểm tra nếu sản phẩm có biến thể (variation) thì phải chọn biến thể
    if (product.productType == ProductType.variable.toString() &&
        variationController.selectedVariation.value.id.isEmpty) {
      CLoaders.customToast(message: 'Vui lòng chọn biến thể (màu sắc, kích cỡ,...)');
      return;
    }

    // Kiểm tra tình trạng tồn kho
    if (product.productType == ProductType.variable.toString()) {
      if (variationController.selectedVariation.value.stock < 1) {
        CLoaders.warningSnackBar(message: 'Biến thể bạn chọn đã hết hàng.', title: 'Ối!');
        return;
      }
    } else {
      if (product.stock < 1) {
        CLoaders.warningSnackBar(message: 'Sản phẩm này đã hết hàng.', title: 'Ối!');
        return;
      }
    }
    // Chuyển đổi ProductModel → CartItemModel
    final selectedCartItem = convertToCartItem(product, productQuantityInCart.value);

    // Kiểm tra xem sản phẩm + biến thể đã có trong giỏ chưa
    int index = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == selectedCartItem.productId &&
          cartItem.variationId == selectedCartItem.variationId,
    );

    if (index >= 0) {
      // Đã có → cập nhật số lượng (thay vì add mới)
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      // Chưa có → thêm mới vào danh sách
      cartItems.add(selectedCartItem);
    }

    updateCart(); // Cập nhật tổng tiền, số lượng, lưu trữ...

    CLoaders.customToast(message: 'Sản phẩm đã được thêm vào giỏ hàng.');
  }

  /// Tăng 1 sản phẩm vào giỏ (dùng cho nút +)
  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == item.productId && cartItem.variationId == item.variationId,
    );

    if (index >= 0) {
      cartItems[index].quantity += 1;
    } else {
      cartItems.add(item);
    }

    updateCart();
  }

  /// Giảm 1 sản phẩm khỏi giỏ (dùng cho nút -)
  void removeOneFromCart(CartItemModel item) {
    int index = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == item.productId && cartItem.variationId == item.variationId,
    );

    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        // Show dialog before completely removing
        cartItems[index].quantity == 1 ? removeFromCartDialog(index) : cartItems.removeAt(index);
      }
    }

    updateCart();
  }

  /// Hiển thị dialog xác nhận xóa sản phẩm (khi số lượng còn 1)
  void removeFromCartDialog(int index) {
    Get.defaultDialog(
      title: 'Xóa sản phẩm',
      middleText: 'Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng không?',
      onConfirm: () {
        // Remove the item from the cart
        cartItems.removeAt(index);
        updateCart();
        CLoaders.customToast(message: 'Sản phẩm đã được xóa khỏi giỏ hàng.');
        Get.back();
      },
      onCancel: () => Get.back(),
    );
  }

  /// Chuyển đổi từ ProductModel sang CartItemModel
  CartItemModel convertToCartItem(ProductModel product, int quantity) {
    // Với sản phẩm đơn (single) → reset biến thể đã chọn
    if (product.productType == ProductType.single.toString()) {
      variationController.resetSelectedAttributes();
    }

    final variation = variationController.selectedVariation.value;
    final isVariation = variation.id.isNotEmpty;

    // Xác định giá (ưu tiên giá sale nếu có)
    final price = isVariation
        ? (variation.salePrice > 0.0 ? variation.salePrice : variation.price)
        : (product.salePrice > 0.0 ? product.salePrice : product.price);

    return CartItemModel(
      productId: product.id,
      title: product.title,
      price: price,
      quantity: quantity,
      variationId: variation.id,
      image: isVariation ? variation.image : product.thumbnail,
      brandName: product.brand != null ? product.brand!.name : '',
      selectedVariation: isVariation ? variation.attributeValues : null,
    );
  }

  /// Cập nhật toàn bộ thông tin giỏ hàng (tổng tiền, số lượng, lưu local)
  void updateCart() {
    updateCartTotals();
    saveCartItems();
    cartItems.refresh(); // Thông báo UI cập nhật
  }

  /// Tính toán lại tổng tiền và tổng số lượng sản phẩm
  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      calculatedTotalPrice += (item.price * item.quantity.toDouble());
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    noOfCartItems.value = calculatedNoOfItems;
  }

  /// Lưu danh sách giỏ hàng vào local storage (dạng JSON string list)
  void saveCartItems() {
    final cartItemStrings = cartItems.map((item) => item.toJson()).toList();
    CLocalStorage.instance().saveData('cartItems', cartItemStrings);
  }

  /// Tải giỏ hàng từ local storage khi khởi động app
  void loadCartItems() {
    final cartItemStrings = CLocalStorage.instance().readData<List<dynamic>>('cartItems');

    if (cartItemStrings != null) {
      cartItems.assignAll(
        cartItemStrings
            .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
      updateCartTotals();
    }
  }

  /// Lấy tổng số lượng của một sản phẩm (tất cả biến thể) trong giỏ
  int getProductQuantityInCart(String productId) {
    return cartItems
        .where((item) => item.productId == productId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);
  }

  /// Lấy số lượng của một biến thể cụ thể trong giỏ
  int getVariationQuantityInCart(String productId, String variationId) {
    final foundItem = cartItems.firstWhere(
      (item) => item.productId == productId && item.variationId == variationId,
      orElse: () => CartItemModel.empty(),
    );
    return foundItem.quantity;
  }

  /// Xóa sạch toàn bộ giỏ hàng
  void clearCart() {
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}
