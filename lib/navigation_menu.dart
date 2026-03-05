import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/features/personalization/screens/settings/settings.dart';
import 'package:shop_app/features/shop/screens/home/home.dart';
import 'package:shop_app/features/shop/screens/store/store.dart';
import 'package:shop_app/features/shop/screens/wishlist/wishlist.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 70,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(Icons.home_filled, color: Colors.green),
              icon: Icon(Icons.home_filled),
              label: "Trang chủ",
            ),
            NavigationDestination(
              selectedIcon: Icon(Iconsax.shop, color: Colors.green),
              icon: Icon(Iconsax.shop),
              label: "Cửa hàng",
            ),
            NavigationDestination(
              selectedIcon: Icon(Iconsax.heart, color: Colors.red),
              icon: Icon(Iconsax.heart),
              label: "Yêu thích",
            ),
            NavigationDestination(
              selectedIcon: Icon(Iconsax.user, color: Colors.green),
              icon: Icon(Iconsax.user),
              label: "Hồ sơ",
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [HomeScreen(), StoreScreen(), FavouriteScrenn(), SettingScreen()];
}
