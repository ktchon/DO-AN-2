import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shop_app/features/authentication/controller/forget_password/forget_password_controller.dart';
import 'package:shop_app/features/authentication/screens/login/login.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: () => Get.back(), icon: Icon(CupertinoIcons.clear))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // hình ảnh
              Image(
                image: AssetImage("assets/onboarding/Onboarding-rafiki.png"),
                width: 200,
                height: 300,
              ),
              // văn bản
              Text(
                'Email Đặt Lại Mật Khẩu Đã Được Gửi',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'An toàn tài khoản là ưu tiên hàng đầu của chúng tôi!'
                'Chúng tôi đã gửi cho bạn một đường dẫn bảo mật'
                'để bạn có thể thay đổi mật khẩu một cách an toàn và giữ tài khoản luôn được bảo vệ',
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              //nút
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(LoginScreen()),
                  child: Text("Xong"),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () =>
                      ForgotPasswordController.instance.resendPasswordResetEmail(email),
                  child: Text("Gửi lại email"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
