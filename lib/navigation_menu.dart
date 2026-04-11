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
    // Đăng ký sớm để Firestore stream bắt đầu ngay khi vào app
    Get.put(NotificationController());

    return Scaffold(
      bottomNavigationBar: Obx(() {
        // ⚠️ QUAN TRỌNG: đọc unreadCount BÊN TRONG Obx
        // để NavigationBar rebuild khi count thay đổi
        final unread = Get.find<NotificationController>().unreadCount.value;
        final selectedIndex = controller.selectedIndex.value;

        return NavigationBar(
          height: 70,
          elevation: 0,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
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
            NavigationDestination(
              selectedIcon: _BadgeIcon(
                icon: Iconsax.notification_copy,
                color: Colors.green,
                count: unread,
              ),
              icon: _BadgeIcon(
                icon: Iconsax.notification_copy,
                count: unread,
              ),
              label: 'Thông báo',
            ),
            const NavigationDestination(
              selectedIcon: Icon(Iconsax.user_copy, color: Colors.green),
              icon: Icon(Iconsax.user_copy),
              label: 'Hồ sơ',
            ),
          ],
        );
      }),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

/// Widget badge đỏ — nhận count từ ngoài, không cần Obx bên trong
class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final int count;

  const _BadgeIcon({
    required this.icon,
    required this.count,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: color),
        if (count > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints:
                  const BoxConstraints(minWidth: 16, minHeight: 16),
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