import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/common/widgets/products/cart/coupon_widget.dart';
import 'package:shop_app/features/shop/controllers/order_controller.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
import 'package:shop_app/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:shop_app/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:shop_app/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:shop_app/features/shop/screens/checkout/widgets/billinng_address_section.dart';
import 'package:shop_app/features/shop/screens/payment/qr_payment.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/helpers/pricing_calculator.dart';
import 'package:shop_app/utils/popups/loaders.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final subTotal = cartController.totalCartPrice.value;
    final orderController = Get.put(OrderController());
    final totalAmount = CPricingCalculator.calculateTotalPrice(subTotal, 'Hồ Chí Minh');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Xem lại đơn hàng',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Sản phẩm
              CartItems(showAddRemoveButton: false),
              SizedBox(height: 30),
              // Mã giảm giá
              CouponCode(),
              SizedBox(height: 30),
              // Số lượng đơn hàng
              RoundedContainer(
                showBorder: true,
                borderColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.grey,
                child: Column(
                  children: [
                    // Tính tiền
                    BillingAmountSection(),
                    SizedBox(height: 12),
                    // Phương thức thanh toán
                    BillingPaymentSection(),
                    SizedBox(height: 12),
                    // Địa chỉ
                    BillinngAddressSection(),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: subTotal > 0
              ? () async {
                  final paymentMethod =
                      orderController.checkoutController.selectedPaymentMethod.value.name;

                  if (paymentMethod == "Chuyển khoản ngân hàng") {
                    Get.to(() => QRPaymentScreen(amount: totalAmount));
                  }
                  /// COD
                  else {
                    await orderController.processOrder(totalAmount);
                  } 
                }
              : () => CLoaders.errorSnackBar(
                  title: 'Giỏ hàng trống',
                  message: 'Vui lòng thêm sản phẩm vào giỏ hàng để tiếp tục thanh toán.',
                ),
          child: Text('Thanh Toán ${totalAmount}'),
        ),
      ),
    ); 
  }
}
