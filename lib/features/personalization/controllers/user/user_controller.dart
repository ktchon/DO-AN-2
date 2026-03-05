import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/data/repositories/user/user_repository.dart';
import 'package:shop_app/features/authentication/screens/login/login.dart';
import 'package:shop_app/features/personalization/models/user_model.dart';
import 'package:shop_app/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:shop_app/utils/helpers/network_manager.dart';
import 'package:shop_app/utils/popups/full_screen_loader.dart';
import 'package:shop_app/utils/popups/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  /// Kho lưu trữ
  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;
  final imageUploading = false.obs;
  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  /// init user data when Home Screen appears
  @override
  void onInit() {
    fetchUserRecord();
    super.onInit();
  }

  /// Fetch user record
  Future<void> fetchUserRecord({bool fetchLatestRecord = false}) async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
      profileLoading.value = false;
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  /// Save user Record from any Registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      // First UPDATE Rx User and then check if user data is already stored. If not store new data
      await fetchUserRecord();

      // If no record already stored.
      if (this.user.value.id.isEmpty) {
        if (userCredentials != null) {
          // Convert Name to First and Last Name
          final nameParts = UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final username = UserModel.generateUsername(userCredentials.user!.displayName ?? '');

          // Map Data
          final user = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts[0],
            lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            username: username,
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '',
          );

          // Save user data
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      CLoaders.warningSnackBar(
        title: 'Dữ liệu chưa được lưu',
        message:
            'Đã xảy ra lỗi khi lưu thông tin của bạn. Bạn có thể lưu lại dữ liệu trong phần Hồ sơ',
      );
    }
  }

  /// Delete Account Warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(16),
      title: 'Xóa tài khoản',
      middleText:
          'Bạn có chắc chắn muốn xóa tài khoản vĩnh viễn không? Hành động này không thể hoàn tác và toàn bộ dữ liệu của bạn sẽ bị xóa vĩnh viễn.',
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Delete')),
      ),
      cancel: OutlinedButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
      ),
    );
  }

  /// Delete User Account
  void deleteUserAccount() async {
    try {
      CFullScreenLoader.openLoadingDialog('Đang xử lý', 'assets/logo/Loading.json');

      /// First re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider = auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        // Re Verify Auth Email
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          CFullScreenLoader.stopLoading();
          Get.offAll(() => LoginScreen());
        } else if (provider == 'password') {
          CFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      CFullScreenLoader.stopLoading();
      CLoaders.warningSnackBar(title: 'Đã có lỗi xảy ra!', message: e.toString());
    }
  }

  /// -- RE-AUTHENTICATE before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      CFullScreenLoader.openLoadingDialog('Đang xử lý', 'assets/logo/Loading.json');

      //Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        CFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(
        verifyEmail.text.trim(),
        verifyPassword.text.trim(),
      );
      await AuthenticationRepository.instance.deleteAccount();
      CFullScreenLoader.stopLoading();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      CFullScreenLoader.stopLoading();
      CLoaders.warningSnackBar(title: 'Đã có lỗi xảy ra!', message: e.toString());
    }
  }

  /// Upload Profile Image
  uploadUserProfilePicture() async {
    try {
      imageUploading.value = true;
      // Chọn ảnh từ gallery với chất lượng nén và kích thước giới hạn
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Chất lượng ảnh (70% để giảm dung lượng)
        maxHeight: 512, // Giới hạn chiều cao
        maxWidth: 512, // Giới hạn chiều rộng
      );

      if (image != null) {
        // Upload ảnh lên Storage và lấy URL download
        final imageUrl = await userRepository.uploadImage(
          'Users/Images/Profile/', // Đường dẫn folder trên Firebase Storage
          image,
        );

        // Tạo map dữ liệu để update field ProfilePicture
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};

        // Cập nhật field đơn lẻ trong Firestore (thường là document của user hiện tại)
        await userRepository.updateSingleField(json);

        // Cập nhật giá trị trong model/user observable (ví dụ GetX, Riverpod, hoặc ValueNotifier)
        user.value.profilePicture = imageUrl;
        user.refresh();

        // Hiện snackbar thành công
        CLoaders.successSnackBar(
          title: 'Chúc mừng!',
          message: 'Ảnh đại diện của bạn đã được cập nhật!',
        );
      }
    } catch (e) {
      // Xử lý lỗi và hiện snackbar lỗi
      CLoaders.errorSnackBar(title: 'Ồ không!', message: 'Có lỗi xảy ra: $e');
    } finally {
      imageUploading.value = false;
    }
  }
}
