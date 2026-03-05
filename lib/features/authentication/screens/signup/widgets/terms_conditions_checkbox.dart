import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shop_app/features/authentication/controller/signup/sigup_controller.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class TermsAndConditionsCheckbox extends StatelessWidget {
  const TermsAndConditionsCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = SignUpController.instance;
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Obx(
            () => Checkbox(
              value: controller.privacyPolicy.value,
              onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "I agree to ", style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                  text: "Chính sách Bảo mật",
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    decoration: TextDecoration.underline,
                    color: dark ? TColors.white : TColors.accent,
                    decorationColor: dark ? TColors.white : TColors.accent,
                  ),
                ),
                TextSpan(text: " và ", style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                  text: "Điều khoản Sử dụng",
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    decoration: TextDecoration.underline,
                    color: dark ? TColors.white : TColors.accent,
                    decorationColor: dark ? TColors.white : TColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
