import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/widgets/loaders/animation_loader.dart';
import 'package:shop_app/common/widgets/loaders/circular_loader.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

/// A utility class for managing a full-screen loading dialog.
class CFullScreenLoader {
  /// Open a full-screen loading dialog with text and animation
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: THelperFunctions.isDarkMode(Get.context!) ? TColors.darkContainer : TColors.white,

          /// Center giúp tránh overflow và luôn căn giữa loader
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [CAnimationLoaderWidget(text: text, animation: animation)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Popup circular loader (small loader)
  static void popUpCircular() {
    Get.defaultDialog(
      title: '',
      onWillPop: () async => false,
      content: const CCircularLoader(),
      backgroundColor: Colors.transparent,
    );
  }

  /// Close the currently opened loading dialog safely
  static void stopLoading() {
    if (Get.overlayContext != null && Navigator.canPop(Get.overlayContext!)) {
      Navigator.of(Get.overlayContext!).pop();
    }
  }
}
