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
    this.buttonAdd = false,
    this.titleButton = "Tiếp theo",
    this.onPressed1, this.titleButton1,
  });

  final String title, subTitle;
  final String? image;
  final VoidCallback? onPressed, onPressed1;
  final double? width, height;
  final EdgeInsetsGeometry padding;
  final bool check;
  final String? animationJson;
  final bool? buttonAdd;
  final String? titleButton, titleButton1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              // Hình ảnh hoặc Animation - check null an toàn
              if (check)
                // Nếu check = true → ưu tiên hiển thị image nếu có, fallback animation nếu không
                (image != null
                    ? Image(
                        image: AssetImage(image!),
                        width: width,
                        height: height,
                        fit: BoxFit.contain,
                      )
                    : (animationJson != null
                          ? Lottie.asset(
                              animationJson!,
                              width: width,
                              height: height,
                              repeat: false,
                            )
                          : const Icon(Icons.check_circle, size: 150, color: Colors.green)))
              else
                // Nếu check = false → chỉ hiển thị animation nếu có
                (animationJson != null
                    ? Lottie.asset(animationJson!, width: width, height: height, repeat: false)
                    : const Icon(Icons.check_circle, size: 150, color: Colors.green)),

              const SizedBox(height: 32),

              // Tiêu đề
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Phụ đề
              Text(
                subTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Nút
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: onPressed, child: Text("$titleButton")),
              ),
              SizedBox(height: 12),
              if (buttonAdd == true)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(onPressed: onPressed1, child: Text("$titleButton1")),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
