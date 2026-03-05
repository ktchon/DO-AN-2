import 'package:flutter/material.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/device/device_utility.dart';

class CTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CTabBar({super.key, required this.tabs});
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: THelperFunctions.isDarkMode(context) ? Colors.black : Colors.white,
      child: TabBar(
        isScrollable: true,
        indicatorColor: Colors.blueAccent,
        unselectedLabelColor: Colors.grey,
        labelColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
        tabs: tabs,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
