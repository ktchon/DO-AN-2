import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_image.dart';
import 'package:shop_app/common/widgets/text/brand_title_text.dart';
import 'package:shop_app/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:shop_app/common/widgets/text/product_price_text.dart';
import 'package:shop_app/common/widgets/text/product_title_text.dart';
import 'package:shop_app/features/shop/controllers/products/product_controller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/constants/enums.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class ProductMetaData extends StatelessWidget {
  const ProductMetaData({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircularContainer(
              height: 28,
              width: 50,
              radius: 10,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              backgroundColor: Colors.yellowAccent.withOpacity(0.8),
              child: Text(
                '$salePercentage%',
                style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.black),
              ),
            ),
            SizedBox(width: 5),
            if (product.productType == ProductType.single.toString() && product.salePrice > 0)
              ProductPriceText(price: product.price, lineThrough: true, isLarge: false),
            SizedBox(width: 5),
            if (product.productType == ProductType.single.toString() && product.salePrice > 0)
              ProductPriceText(price: controller.getProductPrice(product)),
          ],
        ),
        SizedBox(height: 10),
        Row(children: [ProductTitleText(text: product.title)]),
        SizedBox(height: 10),
        Row(
          children: [
            BrandTitleText(title: 'Trạng thái: '),
            Text(
              controller.getProductStockStatus(product.stock),
              style: Theme.of(context).textTheme.titleMedium!.apply(
                color: controller.getProductStockStatus(product.stock).contains('Còn hàng')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
        Row(
          children: [
            CircularImage(
              isNetworkImage: true,
              width: 40,
              height: 40,
              image: product.brand != null ? product.brand!.image : '',
              overlayColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
            ),

            BrandTitleWithVerifiedIcon(title: product.brand != null ? product.brand!.name : ''),
          ],
        ),
      ],
    );
  }
}
