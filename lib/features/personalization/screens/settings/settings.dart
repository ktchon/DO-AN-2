import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/appbar/appbar.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:shop_app/common/widgets/list_titles/settings_menu_tile.dart';
import 'package:shop_app/common/widgets/list_titles/user_profile_tile.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/features/personalization/screens/address/address.dart';
import 'package:shop_app/features/personalization/screens/settings/test_upload/test_upload.dart';
import 'package:shop_app/features/shop/screens/order/order.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // header
          PrimaryHeaderContainer(
            child: Column(
              children: [
                // appbar
                Appbar(
                  title: Text(
                    'Account',
                    style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
                  ),
                ),
                // list title
                UserProfileTile(),
                SizedBox(height: 32),
              ],
            ),
          ),
          // body
          Column(
            children: [
              // Account settings
              Padding(
                padding: EdgeInsets.all(20),
                child: SectionHeading(textTitle: 'Account Settings', showActionButton: false),
              ),
              // List title
              SettingMenuTile(
                title: 'Địa chỉ của tôi',
                subTitle: 'Thiết lập địa chỉ giao hàng mua sắm',
                icon: Iconsax.home_2_copy,
                onTap: () => Get.to(AddressScreen()),
              ),
              SettingMenuTile(
                title: 'Giỏ hàng của tôi',
                subTitle: 'Thêm, xóa sản phẩm và chuyển sang thanh toán',
                icon: Iconsax.shopping_bag_copy,
                onTap: () {},
              ),
              SettingMenuTile(
                title: 'Đơn hàng của tôi',
                subTitle: 'Đơn hàng đang xử lý và đã hoàn thành',
                icon: Iconsax.receipt_2_copy,
                onTap: () => Get.to(() => OrderScreen()),
              ),
              SettingMenuTile(
                title: 'Tài khoản ngân hàng',
                subTitle: 'Rút số dư về tài khoản ngân hàng đã đăng ký',
                icon: Iconsax.bank_copy,
                onTap: () {},
              ),
              SettingMenuTile(
                title: 'Mã giảm giá của tôi',
                subTitle: 'Danh sách tất cả các mã giảm giá / coupon',
                icon: Iconsax.discount_shape,
                onTap: () {},
              ),
              SettingMenuTile(
                title: 'Thông báo',
                subTitle: 'Thiết lập các loại thông báo',
                icon: Icons.notifications,
                onTap: () {},
              ),
              SettingMenuTile(
                title: 'Quyền riêng tư tài khoản',
                subTitle: 'Quản lý việc sử dụng dữ liệu và các tài khoản liên kết',
                icon: Icons.privacy_tip,
                onTap: () {},
              ),

              // App settings
              Padding(
                padding: EdgeInsets.all(20),
                child: SectionHeading(textTitle: 'App Settings', showActionButton: false),
              ),
              // List title
              SettingMenuTile(
                title: 'Đồng bộ dữ liệu',
                subTitle: 'Tải dữ liệu lên Cloud Firebase của bạn',
                icon: Icons.cloud_upload,
                onTap: () => Get.to(TestUpload()),
              ),
              SettingMenuTile(
                title: 'Vị trí',
                subTitle: 'Thiết lập gợi ý dựa trên vị trí',
                icon: Iconsax.location_copy,
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
              SettingMenuTile(
                title: 'Chế độ an toàn',
                subTitle: 'Kết quả tìm kiếm an toàn cho mọi lứa tuổi',
                icon: Iconsax.shield_tick,
                trailing: Switch(value: false, onChanged: (value) {}),
              ),
              SettingMenuTile(
                title: 'Chất lượng hình ảnh HD',
                subTitle: 'Thiết lập chất lượng hình ảnh hiển thị',
                icon: Iconsax.gallery,
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => AuthenticationRepository.instance.logout(),
                    child: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ],
      ),
    );
  }
}
