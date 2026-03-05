import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/data/repositories/user/user_repository.dart';
import 'package:shop_app/features/personalization/controllers/user/user_controller.dart';
import 'package:shop_app/features/personalization/screens/profile/profile.dart';
import 'package:shop_app/utils/helpers/network_manager.dart';
import 'package:shop_app/utils/popups/full_screen_loader.dart';
import 'package:shop_app/utils/popups/loaders.dart';

/// Bộ điều khiển để quản lý các chức năng liên quan đến người dùng.
class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();

  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());

  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  /// Khởi tạo dữ liệu người dùng khi màn hình xuất hiện
  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  /// Lấy thông tin người dùng
  Future<void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }

  Future<void> updateUserName() async {
    try {
      // Bắt đầu hiển thị loading
      CFullScreenLoader.openLoadingDialog(
        'Chúng tôi đang cập nhật thông tin của bạn...',
        'assets/logo/Loading.json',
      );

      // Kiểm tra kết nối Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // Kiểm tra tính hợp lệ của form
      if (!updateUserNameFormKey.currentState!.validate()) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // Cập nhật họ và tên người dùng trong Firebase Firestore
      Map<String, dynamic> name = {
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim(),
      };
      await userRepository.updateSingleField(name);

      // Cập nhật giá trị Rx User
      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();

      // Đóng loading
      CFullScreenLoader.stopLoading();

      // Hiển thị thông báo thành công
      CLoaders.successSnackBar(
        title: 'Chúc mừng',
        message: 'Tên của bạn đã được cập nhật thành công.',
      );

      // Quay về màn hình trước đó
      Get.off(() => const ProfileScreen());
    } catch (e) {
      CFullScreenLoader.stopLoading();
      CLoaders.errorSnackBar(title: 'Có gì đó không ổn!', message: e.toString());
    }
  }
}
