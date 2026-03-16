import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/common/widgets/success_screen/success_screen.dart';
import 'package:shop_app/data/orders/order_repository.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/features/personalization/controllers/address_controller.dart';
import 'package:shop_app/features/shop/controllers/checkout_controller.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';
import 'package:shop_app/features/shop/models/order_model.dart';
import 'package:shop_app/navigation_menu.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/popups/full_screen_loader.dart';
import 'package:shop_app/utils/popups/loaders.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  // Dependencies (các controller khác)

  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  // Danh sách đơn hàng (observable để UI tự update)
  final RxInt noOfOrderItems = 0.obs;
  RxList<OrderModel> userOrders = <OrderModel>[].obs;

  /// Lấy lịch sử đơn hàng của người dùng hiện tại
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final orders = await orderRepository.fetchUserOrders();
      userOrders.assignAll(orders); // cập nhật RxList để UI reactive
      /// cập nhật số đơn hàng
      noOfOrderItems.value = orders.length;
      return orders;
    } catch (e) {
      CLoaders.warningSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    }
  }

  /// Xử lý đặt hàng: tạo order → lưu Firestore → xóa giỏ hàng → chuyển màn hình thành công
  Future<void> processOrder(double totalAmount) async {
    try {
      // Mở full-screen loading
      CFullScreenLoader.openLoadingDialog(
        'Đang xử lý đơn hàng của bạn...',
        'assets/logo/Loading.json',
      );

      // Lấy user ID
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null || userId.isEmpty) {
        CLoaders.errorSnackBar(
          title: 'Lỗi xác thực',
          message: 'Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại.',
        );
        CFullScreenLoader.stopLoading();
        return;
      }

      // Tạo model đơn hàng
      final order = OrderModel(
        id: UniqueKey().toString(), // hoặc dùng UID, Firestore auto ID nếu muốn
        userId: userId,
        status: OrderStatus.processing,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now().add(const Duration(days: 3)),
        items: cartController.cartItems.toList(),
        paymentNote: '',
      );

      // Lưu đơn hàng vào Firestore
      await orderRepository.saveOrder(order, userId);
      // Xóa giỏ hàng sau khi đặt thành công
      cartController.clearCart();

      // Đóng loading
      CFullScreenLoader.stopLoading();

      // Chuyển sang màn hình thành công
      Get.off(
        () => SuccessScreen(
          onPressed: () => Get.offAll(() => NavigationMenu()),
          width: 150,
          height: 150,
          title: 'Đặt hàng Thành Công',
          subTitle: 'Sản phẩm của bạn sẽ được giao đến nơi từ 3-5 ngày',
          animationJson: 'assets/logo/Success.json',
          check: false,
        ),
      );
    } catch (e) {
      CFullScreenLoader.stopLoading();
      CLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
    }
  }

  Future<void> cancelOrder(OrderModel order, String reason) async {
    try {
      /// Lấy userId
      final userId = AuthenticationRepository.instance.authUser?.uid;

      if (userId == null) {
        CLoaders.errorSnackBar(title: "Lỗi", message: "Không tìm thấy người dùng");
        return;
      }

      /// Không cho huỷ nếu đã ship
      if (order.status != OrderStatus.processing) {
        CLoaders.warningSnackBar(title: "Không thể huỷ", message: "Đơn hàng đã được xử lý");
        return;
      }

      /// Loading
      CFullScreenLoader.openLoadingDialog("Đang huỷ đơn hàng...", "assets/logo/Loading.json");

      /// Update Firestore
      await orderRepository.cancelOrder(userId: userId, orderId: order.id, reason: reason);

      /// Update local state
      final index = userOrders.indexWhere((o) => o.id == order.id);

      if (index != -1) {
        userOrders[index] = order.copyWith(status: OrderStatus.cancelled, cancelReason: reason);

        userOrders.refresh();
      }

      CLoaders.successSnackBar(title: "Đã huỷ đơn", message: "Đơn hàng của bạn đã được huỷ");
    } catch (e) {
      CLoaders.errorSnackBar(title: "Lỗi", message: e.toString());
    } finally {
      CFullScreenLoader.stopLoading();
    }
  }

  void showCancelDialog(BuildContext context, OrderModel order) {
    final reasons = [
      "Đặt nhầm sản phẩm",
      "Muốn thay đổi sản phẩm",
      "Thời gian giao quá lâu",
      "Tìm được giá rẻ hơn",
      "Lý do khác",
    ];

    String selectedReason = reasons.first;
    final TextEditingController otherReasonController = TextEditingController();

    Get.defaultDialog(
      title: "Huỷ đơn hàng",
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                const Text("Vui lòng chọn lý do huỷ đơn"),
                const SizedBox(height: 10),

                /// danh sách lý do
                ...reasons.map((reason) {
                  return RadioListTile(
                    value: reason,
                    groupValue: selectedReason,
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value.toString();
                      });
                    },
                    title: Text(reason),
                  );
                }).toList(),

                /// nếu chọn lý do khác
                if (selectedReason == "Lý do khác")
                  TextField(
                    controller: otherReasonController,
                    decoration: const InputDecoration(hintText: "Nhập lý do của bạn"),
                  ),
              ],
            );
          },
        ),
      ),

      textCancel: "Không",
      textConfirm: "Huỷ đơn",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,

      onConfirm: () {
        Get.back();

        final reason = selectedReason == "Lý do khác" ? otherReasonController.text : selectedReason;

        OrderController.instance.cancelOrder(order, reason);
      },
    );
  }

  Map<String, dynamic> calculateOrderTotals(List<CartItemModel> items) {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in items) {
      calculatedTotalPrice += item.price * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
    }

    return {'totalPrice': calculatedTotalPrice, 'totalItems': calculatedNoOfItems};
  }

  Future<void> createPendingOrder(double amount, String paymentNote) async {
    final userId = AuthenticationRepository.instance.authUser!.uid;

    final order = OrderModel(
      id: paymentNote,
      userId: userId,
      status: OrderStatus.pending,
      totalAmount: amount,
      orderDate: DateTime.now(),
      paymentMethod: "bank_transfer",
      paymentNote: paymentNote,
      address: addressController.selectedAddress.value,
      deliveryDate: DateTime.now().add(const Duration(days: 3)),
      items: cartController.cartItems.toList(),
    );

    try {
      // 1. Lưu order chính vào subcollection
      await orderRepository.saveOrder(order, userId);

      // 2. Lưu mapping root-level để webhook query nhanh
      await FirebaseFirestore.instance
          .collection(
            "OrderIds",
          ) // tên collection root-level, bạn có thể đổi thành "PaymentMappings" nếu thích
          .doc(paymentNote) // doc ID chính là ORDERxxxx (unique)
          .set({
            'userId': userId,
            'orderId': paymentNote,
            'createdAt': FieldValue.serverTimestamp(),
            'totalAmount': amount, // optional, để webhook check nhanh nếu cần
            'status': 'pending', // optional, để dễ quản lý sau này
          });

      print("Đã lưu mapping OrderIds cho: $paymentNote");
    } catch (e) {
      print("Lỗi khi tạo pending order hoặc mapping: $e");
      // Nếu muốn, bạn có thể throw hoặc xử lý lỗi ở đây
      // Ví dụ: throw Exception("Không thể tạo đơn hàng");
    }
  }

  Future<void> cancelPendingOrder(String paymentNote) async {
    final userId = AuthenticationRepository.instance.authUser?.uid;
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("Orders")
          .doc(paymentNote)
          .delete();
      userOrders.removeWhere((o) => o.id == paymentNote);
      userOrders.refresh();
    } catch (e) {
      CLoaders.errorSnackBar(title: "Lỗi", message: e.toString());
    }
  }
}
