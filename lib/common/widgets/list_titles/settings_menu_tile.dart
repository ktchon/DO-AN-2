import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/icons/circular_icon.dart';

class SettingMenuTile extends StatelessWidget {
  const SettingMenuTile({
    required this.title,
    required this.subTitle,
    required this.icon,
    this.onTap,
    this.trailing,
    super.key,
  });
  final String title, subTitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircularIcon(icon: icon, size: 28, color: Colors.blueAccent,),
      title: Text(title),
      subtitle: Text(
        subTitle,
        style: Theme.of(context).textTheme.bodySmall!.apply(color: Colors.grey),
      ),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
