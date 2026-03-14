import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/features/shop/controllers/checkout_controller.dart';
import 'package:shop_app/features/shop/models/payment_method_model.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class CPaymentTile extends StatelessWidget {
  const CPaymentTile({super.key, required this.paymentMethod});

  final PaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;

    final bool isDark = THelperFunctions.isDarkMode(context);

    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        // Cập nhật phương thức đã chọn
        controller.selectedPaymentMethod.value = paymentMethod;
        // Đóng bottom sheet
        Get.back();
      },
      leading: RoundedContainer(
        width: 60,
        height: 40,
        backgroundColor: isDark ? Colors.black : Colors.white,
        padding: const EdgeInsets.all(12),
        child: Image(image: AssetImage(paymentMethod.image), fit: BoxFit.contain),
      ),
      title: Text(paymentMethod.name),
      trailing: const Icon(Iconsax.arrow_right_3_copy),
    );
  }
}
