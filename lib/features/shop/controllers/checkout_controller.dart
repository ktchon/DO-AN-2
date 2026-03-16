import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/features/shop/models/payment_method_model.dart';
import 'package:shop_app/features/shop/screens/checkout/widgets/payment_title.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  // Rx variable để theo dõi phương thức thanh toán đã chọn
  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.emmpty().obs;

  @override
  void onInit() {
    // Giá trị mặc định khi khởi tạo
    selectedPaymentMethod.value = PaymentMethodModel(name: 'COD', image: 'assets/logo/cod.png');
    super.onInit();
  }

  // Hàm hiển thị bottom sheet chọn phương thức thanh toán
  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              SectionHeading(textTitle: 'Chọn phương thức thanh toán', showActionButton: false),

              SizedBox(height: 32),

              // Danh sách phương thức
              CPaymentTile(
                paymentMethod: PaymentMethodModel(name: 'COD', image: 'assets/logo/cod.png'),
              ),
              SizedBox(height: 20),
              CPaymentTile(
                paymentMethod: PaymentMethodModel(
                  name: 'Chuyển khoản ngân hàng',
                  image: 'assets/logo/qr-code.png',
                ),
              ),
              SizedBox(height: 20),
              CPaymentTile(
                paymentMethod: PaymentMethodModel(
                  name: 'MoMo',
                  image: 'assets/logo/MOMO-Logo-App.png',
                ),
              ),
              SizedBox(height: 20),
              CPaymentTile(
                paymentMethod: PaymentMethodModel(
                  name: 'Thẻ thanh toán',
                  image: 'assets/logo/logo-atm.png',
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
