import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/login_signup/form_divider.dart';
import 'package:shop_app/common/widgets/login_signup/social_buttons.dart';
import 'package:shop_app/features/authentication/screens/login/widgets/login_form.dart';
import 'package:shop_app/features/authentication/screens/login/widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 56, left: 20, right: 20, bottom: 20),
          child: Column(
            children: [
              LoginHeader(),
              SizedBox(height: 15),
              LoginForm(),
              SizedBox(height: 20),
              FormDivider(dividerText: 'Đăng nhập với'),
              SizedBox(height: 20),
              SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
