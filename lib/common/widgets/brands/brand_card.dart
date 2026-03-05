import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_image.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({super.key, this.showBorder = false, this.onTap});
  final bool showBorder;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RoundedContainer(
        padding: const EdgeInsets.all(10),
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        borderColor: Colors.green,
        child: Row(
          children: [
            /// -- Icon
            Flexible(
              child: CircularImage(
                image: 'assets/logo/logo-nike.png',
                overlayColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 16),

            /// -- Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BrandTitleWithVerifiedIcon(title: 'Nike'),
                  Text(
                    '256 products vdfvkv',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ), // Text
                ],
              ),
            ), // Column// Container
          ],
        ),
      ),
    );
  }
}
