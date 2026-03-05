import 'package:flutter/material.dart';

import 'package:shop_app/common/widgets/login_signup/form_divider.dart';
import 'package:shop_app/common/widgets/login_signup/social_buttons.dart';

import 'package:shop_app/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:shop_app/utils/constants/sizes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.indigoAccent),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Hoàn thành để tạo tài khoản",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(height: TSizes.spaceBtwSections),
              FormSignup(),
              // diveder
              SizedBox(height: TSizes.spaceBtwItems),
              FormDivider(dividerText: "Đăng ký với"),
              // socialbutton
              SizedBox(height: TSizes.spaceBtwItems),
              SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
