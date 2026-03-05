import 'package:flutter/material.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.labelText,
    required this.mainText,
    required this.onTap,
    required this.icon,
  });
  final String labelText, mainText;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                labelText,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                mainText,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
                ),
              ),
            ),
            Expanded(child: Icon(icon, size: 18)),
          ],
        ),
      ),
    );
  }
}
