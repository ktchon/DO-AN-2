import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/features/authentication/screens/password_config/reset_password.dart';
import 'package:shop_app/utils/helpers/network_manager.dart';
import 'package:shop_app/utils/popups/full_screen_loader.dart';
import 'package:shop_app/utils/popups/loaders.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send Reset Password EMail
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      CFullScreenLoader.openLoadingDialog('Processing your request...', 'assets/logo/Loading.json');

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // Send Email
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      // Remove Loader
      CFullScreenLoader.stopLoading();

      // Show Success Screen
      CLoaders.successSnackBar(
        title: 'Email Sent',
        message: 'Email Link Sent to Reset your Password'.tr,
      );

      // Redirect
      Get.to(() => ResetPassword(email: email.text.trim()));
    } catch (e) {
      CFullScreenLoader.stopLoading();
      CLoaders.errorSnackBar(title: 'Đã xảy ra lỗi!', message: e.toString());
    }
  }

  /// ReSend Reset Password EMail
  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      CFullScreenLoader.openLoadingDialog('Processing your request...', 'assets/logo/Loading.json');

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CFullScreenLoader.stopLoading();
        return;
      }
      // Send Email
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // Remove Loader
      CFullScreenLoader.stopLoading();

      // Show Success Screen
      CLoaders.successSnackBar(
        title: 'Email Sent',
        message: 'Email Link Sent to Reset your Password'.tr,
      );
    } catch (e) {
      CFullScreenLoader.stopLoading();
      CLoaders.errorSnackBar(title: 'Đã xảy ra lỗi!', message: e.toString());
    }
  }
}
