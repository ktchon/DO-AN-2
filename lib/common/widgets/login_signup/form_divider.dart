import 'package:flutter/material.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/constants/colors.dart';

class FormDivider extends StatelessWidget {
  const FormDivider({super.key, required this.dividerText});

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            thickness: 1,
            indent: 60,
            endIndent: 5,
            color: dark ? TColors.darkGrey : TColors.grey,
          ),
        ),
        Text(dividerText, style: Theme.of(context).textTheme.labelLarge),
        Flexible(
          child: Divider(
            thickness: 1,
            indent: 5,
            endIndent: 60,
            color: dark ? TColors.darkGrey : TColors.grey,
          ),
        ),
      ],
    );
  }
}
