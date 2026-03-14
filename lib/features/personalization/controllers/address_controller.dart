import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/widgets/loaders/circular_loader.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/data/address/address_repository.dart';
import 'package:shop_app/features/personalization/models/address_model.dart';
import 'package:shop_app/features/personalization/screens/address/add_new_address.dart';
import 'package:shop_app/features/personalization/screens/address/widgets/single_address.dart';
import 'package:shop_app/utils/helpers/cloud_helper_functions.dart';
import 'package:shop_app/utils/helpers/network_manager.dart';
import 'package:shop_app/utils/popups/full_screen_loader.dart';
import 'package:shop_app/utils/popups/loaders.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController street = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController country = TextEditingController();

  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;

  final addressRepository = Get.put(AddressRepository());

  /// Lấy tất cả địa chỉ của người dùng và tự động chọn địa chỉ mặc định (nếu có)
  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      final addresses = await addressRepository.fetchUserAddresses();

      // Tìm địa chỉ được chọn (selectedAddress == true), nếu không có thì trả về empty
      selectedAddress.value = addresses.firstWhere(
        (element) => element.selectedAddress,
        orElse: () => AddressModel.empty(),
      );

      return addresses;
    } catch (e) {
      CLoaders.errorSnackBar(title: 'Không tìm thấy địa chỉ', message: e.toString());
      return [];
    }
  }

  /// Chọn một địa chỉ mới làm địa chỉ mặc định (selected)
  Future<void> selectAddress(AddressModel newSelectedAddress) async {
    try {
      Get.defaultDialog(
        title: '', // Không hiển thị title
        titlePadding: EdgeInsets.zero, // (tùy chọn) loại bỏ padding title nếu cần
        contentPadding: EdgeInsets.zero, // (tùy chọn) loại bỏ padding content
        barrierDismissible: false, // Không cho bấm ngoài để tắt dialog
        backgroundColor: Colors.transparent, // Nền trong suốt (thường dùng cho full-screen loader)
        radius: 0, // (tùy chọn) bo góc 0 để full màn hình
        onWillPop: () async => false, // Không cho back button tắt dialog
        content: CCircularLoader(), // Widget loading (giả sử bạn có class này)
      );
      // Xóa trạng thái "selected" của địa chỉ cũ (nếu có)
      if (selectedAddress.value.id.isNotEmpty) {
        await addressRepository.updateSelectedField(selectedAddress.value.id, false);
      }

      // Gán địa chỉ mới được chọn
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      // Cập nhật trường "SelectedAddress" thành true cho địa chỉ mới
      // Set the "selected" field to true for the newly selected address
      await addressRepository.updateSelectedField(selectedAddress.value.id, true);

      // Trở lại
      Get.back();
    } catch (e) {
      CLoaders.errorSnackBar(title: 'Lỗi khi chọn địa chỉ', message: e.toString());
    }
  }

  /// Thêm địa chỉ mới vào Firestore
  Future<void> addNewAddress() async {
    try {
      // Bắt đầu hiển thị loading
      // Start Loading
      CFullScreenLoader.openLoadingDialog('Đang lưu địa chỉ...', 'assets/logo/Loading.json');

      // Kiểm tra kết nối Internet
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // Kiểm tra validate form
      // Form Validation
      if (!addressFormKey.currentState!.validate()) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // Tạo đối tượng AddressModel từ dữ liệu form
      // Save Address Data
      final address = AddressModel(
        id: '',
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        postalCode: postalCode.text.trim(),
        country: country.text.trim(),
        selectedAddress: true, // Đặt làm địa chỉ mặc định khi thêm mới
        dateTime: DateTime.now(),
      );

      // Gọi repository để thêm địa chỉ mới và nhận về ID document
      final id = await addressRepository.addAddress(address);

      // Cập nhật id cho đối tượng address (để dùng ở bước sau)
      address.id = id;

      // Cập nhật trạng thái selected cho địa chỉ mới (và clear các địa chỉ cũ nếu cần)
      await selectAddress(address);

      // Tắt loading
      // Remove Loader
      CFullScreenLoader.stopLoading();

      // Hiển thị thông báo thành công
      // Show Success Message
      CLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Địa chỉ của bạn đã được lưu thành công.',
      );

      // Làm mới dữ liệu địa chỉ (refresh danh sách)
      // Refresh Addresses Data
      refreshData.toggle();

      // Reset các trường input về rỗng
      // Reset fields
      resetFormFields();

      // Quay lại màn hình trước
      // Redirect
      Navigator.of(Get.context!).pop();
    } catch (e) {
      // Tắt loading khi có lỗi
      CFullScreenLoader.stopLoading();

      // Hiển thị thông báo lỗi
      CLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }

  /// Hàm reset các trường input trong form về trạng thái rỗng
  void resetFormFields() {
    name.clear();
    phoneNumber.clear();
    street.clear();
    postalCode.clear();
    city.clear();
    state.clear();
    country.clear();

    // Reset trạng thái validate của Form (xóa lỗi đỏ, đưa form về trạng thái ban đầu)
    addressFormKey.currentState?.reset();
  }

  /// Hiển thị BottomSheet chọn địa chỉ mới tại màn hình Checkout
  Future<dynamic> selectNewAddressPopup(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề phần
                SizedBox(height: 32),
                const SectionHeading(textTitle: 'Chọn địa chỉ', showActionButton: false),
                SizedBox(height: 20),

                // Tải danh sách địa chỉ của người dùng
                Expanded(
                  child: FutureBuilder(
                    future: getAllUserAddresses(),
                    builder: (_, snapshot) {
                      // Xử lý các trạng thái: đang tải, không có dữ liệu, hoặc lỗi
                      final response = CloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
                      if (response != null) return response;
                  
                      // Khi đã có dữ liệu → hiển thị danh sách
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => SingleAddress(
                          address: snapshot.data![index],
                          onTap: () async {
                            await selectAddress(snapshot.data![index]);
                            Get.back();
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                // Nút thêm địa chỉ mới (kéo sang màn hình thêm địa chỉ)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => AddNewAddress()),
                    child: Text('Thêm địa chỉ'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
