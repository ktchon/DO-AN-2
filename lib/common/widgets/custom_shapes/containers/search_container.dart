import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.isReadOnly = true, // Mặc định là chỉ đọc (dùng ở Home)
    this.onTap,
    this.onChanged,
    this.controller,
  });

  final String text;
  final IconData icon;
  final bool isReadOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 12,
          ), // Giảm padding dọc để TextField cân đối
          decoration: BoxDecoration(
            color: dark ? TColors.dark : TColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: TColors.grey),
          ),
          child: Row(
            children: [
              Icon(icon, color: TColors.darkerGrey),
              const SizedBox(width: 8),
              Expanded(
                child: isReadOnly
                    ? Text(text, style: Theme.of(context).textTheme.bodySmall)
                    : TextFormField(
                        controller: controller,
                        onChanged: onChanged,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: text,
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
