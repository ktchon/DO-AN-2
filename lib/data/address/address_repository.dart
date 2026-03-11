import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/features/personalization/models/address_model.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// Lấy tất cả địa chỉ của người dùng hiện tại từ Firestore
  Future<List<AddressModel>> fetchUserAddresses() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;

      if (userId.isEmpty) {
        throw 'Không thể tìm thấy thông tin người dùng. Vui lòng thử lại sau vài phút.';
      }

      final result = await _db.collection('Users').doc(userId).collection('Addresses').get();

      return result.docs
          .map((documentSnapshot) => AddressModel.fromDocumentSnapshot(documentSnapshot))
          .toList();
    } catch (e) {
      throw 'Có lỗi xảy ra khi lấy thông tin địa chỉ. Vui lòng thử lại sau.';
    }
  }

  /// Cập nhật trường "SelectedAddress" cho một địa chỉ cụ thể
  Future<void> updateSelectedField(String addressId, bool selected) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;

      await _db.collection('Users').doc(userId).collection('Addresses').doc(addressId).update({
        'SelectedAddress': selected,
      });
    } catch (e) {
      throw 'Không thể cập nhật lựa chọn địa chỉ của bạn. Vui lòng thử lại sau.';
    }
  }

  /// Lưu địa chỉ mới của người dùng vào Firestore
  /// Trả về ID của document vừa tạo (để cập nhật hoặc sử dụng sau)
  Future<String> addAddress(AddressModel address) async {
    try {
      // Lấy ID người dùng hiện tại từ Authentication
      final userId = AuthenticationRepository.instance.authUser!.uid;

      // Thêm document mới vào sub-collection 'Addresses' của user
      final currentAddress = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .add(address.toJson());

      // Trả về ID document vừa tạo
      return currentAddress.id;
    } catch (e) {
      throw 'Có lỗi xảy ra khi lưu thông tin địa chỉ. Vui lòng thử lại sau.';
    }
  }
}
