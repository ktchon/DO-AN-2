import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_image.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:shop_app/features/shop/models/brand_model.dart';
import 'package:shop_app/utils/helpers/emulator_helper.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({super.key, this.showBorder = false, this.onTap, required this.brand});
  final BrandModel brand;
  final bool showBorder;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final fixedImageUrl = fixEmulatorImageUrl(brand.image);
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
                isNetworkImage: true,
                image: fixedImageUrl,
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
                  BrandTitleWithVerifiedIcon(title: brand.name),
                  Text(
                    "${brand.productsCount ?? 0} Sản phẩm",
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
