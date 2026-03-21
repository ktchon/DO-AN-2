import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart'
    show CartController;
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class CouponCode extends StatelessWidget {
  const CouponCode({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());
    final textController = TextEditingController();
    final dark = THelperFunctions.isDarkMode(context);
    return RoundedContainer(
      showBorder: true,
      borderColor: dark ? Colors.white : Colors.grey,
      padding: EdgeInsets.only(right: 5, left: 10, bottom: 5, top: 5),
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              controller: textController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: 'Nhập mã khuyến mãi tại đây',
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: ValueListenableBuilder(
              valueListenable: textController,
              builder: (context, TextEditingValue value, _) {
                final hasText = value.text.trim().isNotEmpty;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: hasText
                        ? Colors.white
                        : (dark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5)),
                    backgroundColor: hasText
                        ? TColors
                              .accent
                        : Colors.grey.withOpacity(0.2),
                    side: BorderSide(color: hasText ? Colors.blue : Colors.grey.withOpacity(0.1)),
                  ),
                  onPressed: hasText
                      ? () {
                          final subTotal = CartController.instance.totalCartPrice.value;
                          controller.applyCoupon(textController.text.trim(), subTotal);
                        }
                      : null, 
                  child: const Text('Áp dụng'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
