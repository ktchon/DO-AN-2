import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(height: 150, image: AssetImage("assets/logo/logo-app.png")),
        Text("Welcome,", style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 8),
        Text(
          "Hãy bắt đầu đăng nhập tài khoản và bắt đầu mua sắp!",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
