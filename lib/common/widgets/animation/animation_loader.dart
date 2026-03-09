import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Một widget để hiển thị chỉ báo tải hoạt ảnh với văn bản và nút hành động tùy chọn.
class CAnimationLoader extends StatelessWidget {
  const CAnimationLoader({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  });

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hiển thị hoạt ảnh Lottie
          Lottie.asset(animation, width: MediaQuery.of(context).size.width * 0.8),
          const SizedBox(height: 20),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ), // Text
          const SizedBox(height: 20),

          // Kiểm tra xem có hiển thị nút hành động hay không
          showAction
              ? SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: onActionPressed,
                    style: OutlinedButton.styleFrom(backgroundColor: Colors.black),
                    child: Text(
                      actionText!,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white70),
                    ), // Text
                  ), // OutlinedButton
                ) // SizedBox
              : const SizedBox(),
        ],
      ), // Column
    ); // Center
  }
}
