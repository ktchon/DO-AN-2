import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    this.image,
    required this.title,
    required this.subTitle,
    this.onPressed,
    this.width,
    this.height,
    this.padding = const EdgeInsets.only(top: 112, left: 48, right: 48, bottom: 48),
    required this.check,
    this.animationJson,
  });

  final String title, subTitle;
  final String? image;
  final VoidCallback? onPressed;
  final double? width, height;
  final EdgeInsetsGeometry padding;
  final bool check;
  final String? animationJson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              // hình ảnh (Image hoặc Lottie)
              check
                  ? Image(image: AssetImage(image!), width: width, height: height)
                  : Lottie.asset(animationJson!, width: width, height: height, repeat: false),

              // văn bản
              
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              //nút
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: onPressed, child: Text("Tiếp theo")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
