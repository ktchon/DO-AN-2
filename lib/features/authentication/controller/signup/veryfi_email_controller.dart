import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/common/widgets/success_screen/success_screen.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/utils/constants/text_string.dart';
// import 'package:shop_app/utils/popups/loaders.dart';

class VeryfiEmailController extends GetxController {
  static VeryfiEmailController get instance => Get.find();
  @override
  void onInit() {
    /// Gửi Email Bất cứ khi nào Màn hình Xác minh xuất hiện & Đặt Hẹn giờ để tự động chuyển hướng.
    // sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  // /// Send Email Verification link
  // sendEmailVerification() async {
  //   try {
  //     await AuthenticationRepository.instance.sendEmailVerification();
  //     CLoaders.successSnackBar(
  //       title: 'Email đã được gửi',
  //       message: 'Vui lòng kiểm tra hộp thư đến và xác minh email của bạn.',
  //     );
  //   } catch (e) {
  //     CLoaders.errorSnackBar(title: 'Đã xảy ra lỗi!', message: e.toString());
  //   }
  // }

  /// Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(
          () => SuccessScreen(
            animationJson: 'assets/logo/Success.json',
            title: CTexts.yourAccountCreatedTitle,
            subTitle: CTexts.yourAccountCreatedSubTitle,
            onPressed: () => AuthenticationRepository.instance.screenRedirect(),
            check: false,
          ),
        ); // SuccessScreen
      }
    });
  }

  /// Manually Check if Email Verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          animationJson: 'assets/logo/Success.json',
          title: CTexts.yourAccountCreatedTitle,
          subTitle: CTexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
          check: false,
        ),
      );
    }
  }
}
