import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/features/personalization/screens/settings/settings.dart';
import 'package:shop_app/features/shop/controllers/notification/notification_controller.dart';
import 'package:shop_app/features/shop/screens/home/home.dart';
import 'package:shop_app/features/shop/screens/notification/notification_screen.dart';
import 'package:shop_app/features/shop/screens/store/store.dart';
import 'package:shop_app/features/shop/screens/wishlist/wishlist.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    // Đăng ký NotificationController ngay khi vào app
    final notifController = Get.put(NotificationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 70,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: [
            const NavigationDestination(
              selectedIcon: Icon(Iconsax.home_copy, color: Colors.green),
              icon: Icon(Iconsax.home_copy),
              label: 'Trang chủ',
            ),
            const NavigationDestination(
              selectedIcon: Icon(Iconsax.shop_copy, color: Colors.green),
              icon: Icon(Iconsax.shop_copy),
              label: 'Cửa hàng',
            ),
            const NavigationDestination(
              selectedIcon: Icon(Iconsax.heart_copy, color: Colors.red),
              icon: Icon(Iconsax.heart_copy),
              label: 'Yêu thích',
            ),

            // ── THÔNG BÁO với badge đỏ ──
            NavigationDestination(
              selectedIcon: Obx(() => _notifIcon(notifController, selected: true)),
              icon: Obx(() => _notifIcon(notifController, selected: false)),
              label: 'Thông báo',
            ),

            const NavigationDestination(
              selectedIcon: Icon(Iconsax.user_copy, color: Colors.green),
              icon: Icon(Iconsax.user_copy),
              label: 'Hồ sơ',
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }

  Widget _notifIcon(NotificationController notifController, {required bool selected}) {
    final count = notifController.unreadCount.value;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          selected ? Iconsax.notification_copy : Iconsax.notification_copy,
          color: selected ? Colors.green : null,
        ),
        if (count > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    HomeScreen(),
    StoreScreen(),
    FavouriteScrenn(),
    const NotificationScreen(),
    SettingScreen(),
  ];
}
