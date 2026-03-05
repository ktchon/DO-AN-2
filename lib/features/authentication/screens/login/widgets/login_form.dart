import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/features/authentication/controller/login/login_controller.dart';
import 'package:shop_app/features/authentication/screens/password_config/forget_password.dart';
import 'package:shop_app/features/authentication/screens/signup/signup.dart';
import 'package:shop_app/utils/validators/validator.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Column(
        children: [
          //email
          TextFormField(
            controller: controller.email,
            validator: (value) => CValidator.validateEmail(value),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: "Nhập email của bạn",
            ),
          ),
          SizedBox(height: 16),
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => CValidator.validatePassword(value),
              obscureText: controller.hidenPassword.value,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: "Nhập mật khẩu",
                suffixIcon: IconButton(
                  onPressed: () => controller.hidenPassword.value = !controller.hidenPassword.value,
                  icon: controller.hidenPassword.value
                      ? Icon(Iconsax.eye_slash)
                      : Icon(Iconsax.eye),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          // quên mk và ghi nhớ tôi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) =>
                          controller.rememberMe.value = !controller.rememberMe.value,
                    ),
                  ),
                  Text("Ghi nhớ tôi"),
                ],
              ),
              TextButton(
                onPressed: () => Get.to(() => ForgetPassword()),
                child: Text("Quên mật khẩu?"),
              ),
            ],
          ),
          // Nút đăng nhập
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.emailAndPasswordLogin(),
              child: Text("Đăng nhập"),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              // style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              onPressed: () {
                Get.to(() => SignupScreen());
              },
              child: Text("Tạo tài khoản"),
            ),
          ),
        ],
      ),
    );
  }
}
