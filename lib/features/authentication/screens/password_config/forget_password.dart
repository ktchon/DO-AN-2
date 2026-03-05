import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:shop_app/features/authentication/controller/forget_password/forget_password_controller.dart';
import 'package:shop_app/utils/validators/validator.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Quên mật khẩu!", style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 16),
                Text(
                  "Đừng lo, đôi khi ai cũng có thể quên mà!"
                  "Vui lòng nhập địa chỉ email của bạn,"
                  "chúng tôi sẽ gửi cho bạn đường dẫn để đặt lại mật khẩu.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: 32),
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: CValidator.validateEmail,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: "E-mail",
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.sendPasswordResetEmail(),
                child: Text("Gửi đi"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
