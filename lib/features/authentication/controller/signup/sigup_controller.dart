import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/data/repositories/user/user_repository.dart';
import 'package:shop_app/features/authentication/screens/signup/verify_email.dart';
import 'package:shop_app/features/personalization/models/user_model.dart';
import 'package:shop_app/utils/constants/text_string.dart';
import 'package:shop_app/utils/helpers/network_manager.dart';
import 'package:shop_app/utils/popups/full_screen_loader.dart';
import 'package:shop_app/utils/popups/loaders.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs; // Controller ẩn hiện mật khẩu
  final privacyPolicy = false.obs;
  final email = TextEditingController(); // Controller cho ô nhập email
  final lastName = TextEditingController(); // Controller cho ô nhập họ
  final username = TextEditingController(); // Controller cho ô nhập tên đăng nhập
  final password = TextEditingController(); // Controller cho ô nhập mật khẩu
  final firstName = TextEditingController(); // Controller cho ô nhập tên
  final phoneNumber = TextEditingController(); // Controller cho ô nhập số điện thoại

  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(); // Khóa form dùng để validate form đăng ký
  void signup() async {
    try {
      // Kiểm tra kết nối Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      // Xác thực form
      if (!signupFormKey.currentState!.validate()) return;
      // Kiểm tra đã check chính sách bảo mật và điều khoản
      if (!privacyPolicy.value) {
        CLoaders.warningSnackBar(
          title: CTexts.acceptTermsAndPrivacy,
          message: CTexts.termsAndPrivacyRequired,
        );
        return;
      }
      // Bắt đầu tải
      CFullScreenLoader.openLoadingDialog(
        'Chúng tôi đang xử lý thông tin của bạn...',
        'assets/logo/Loading.json',
      );
      // Đăng ký người dùng trong Firebase Authentication & Lưu dữ liệu người dùng vào Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );
      // Lưu dữ liệu người dùng đã xác thực vào Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );
      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);
      // Show Success Message
      CLoaders.successSnackBar(
        title: 'Chúc mừng',
        message: 'Tài khoản của bạn đã được tạo thành công! Vui lòng xác minh email để tiếp tục.',
      );
      // GỬI EMAIL XÁC THỰC
      await userCredential.user!.sendEmailVerification();
      // Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      CFullScreenLoader.stopLoading();
      CLoaders.errorSnackBar(title: 'Đã xảy ra lỗi!', message: e.toString());
    }
  }
}
