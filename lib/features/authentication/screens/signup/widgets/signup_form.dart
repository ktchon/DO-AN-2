import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/features/authentication/controller/signup/sigup_controller.dart';
import 'package:shop_app/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:shop_app/utils/validators/validator.dart';

import '../../../../../utils/constants/sizes.dart';

class FormSignup extends StatelessWidget {
  const FormSignup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) => CValidator.validateEmptyText('Tên', value),
                  expands: false,
                  decoration: InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: "Tên"),
                ),
              ),
              SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  validator: (value) => CValidator.validateEmptyText('Họ', value),
                  controller: controller.lastName,
                  expands: false,
                  decoration: InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: "Họ"),
                ),
              ),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.username,
            validator: (value) => CValidator.validateEmptyText('Tên người dùng', value),
            decoration: InputDecoration(
              prefixIcon: Icon(Iconsax.user_edit),
              labelText: "Tên người dùng",
            ),
          ),
          SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.email,
            validator: (value) => CValidator.validateEmail(value),
            decoration: InputDecoration(prefixIcon: Icon(Icons.email), labelText: "E-mail"),
          ),
          SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => CValidator.validatePhoneNumber(value),
            decoration: InputDecoration(prefixIcon: Icon(Icons.call), labelText: "Số điện thoại"),
          ),
          SizedBox(height: TSizes.spaceBtwInputFields),
          Obx(
            () => TextFormField(
              obscureText: controller.hidePassword.value,
              controller: controller.password,
              validator: (value) => CValidator.validatePassword(value),
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: controller.hidePassword.value
                      ? Icon(Iconsax.eye_slash)
                      : Icon(Iconsax.eye_copy),
                ),
                labelText: "Mật khẩu",
              ),
            ),
          ),
          SizedBox(height: TSizes.spaceBtwInputFields),
          TermsAndConditionsCheckbox(),
          SizedBox(height: TSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: Text("Tạo tài khoản"),
            ),
          ),
        ],
      ),
    );
  }
}
