import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/brands/brand_card.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class BrandShowcase extends StatelessWidget {
  const BrandShowcase({super.key, required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      margin: EdgeInsets.all(16),
      showBorder: true,
      borderColor: Colors.green,
      backgroundColor: THelperFunctions.isDarkMode(context) ? Colors.black : Colors.white,
      child: Column(
        children: [
          BrandCard(),
          Row(children: images.map((image) => BrandTopProductWidget(image, context)).toList()),
        ],
      ),
    );
  }

  Widget BrandTopProductWidget(String image, context) {
    return Expanded(
      child: RoundedContainer(
        showBorder: true,
        backgroundColor: THelperFunctions.isDarkMode(context) ? Colors.grey : Colors.white,
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(0),
        borderColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.green,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image(height: 100, fit: BoxFit.contain, image: AssetImage(image)),
        ),
      ),
    );
  }
}
