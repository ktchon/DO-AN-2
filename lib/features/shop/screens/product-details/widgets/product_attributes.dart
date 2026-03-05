import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:shop_app/common/widgets/chips/choice_chip_atribute.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/common/widgets/text/brand_title_text.dart';
import 'package:shop_app/common/widgets/text/product_price_text.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/features/shop/controllers/products/variation_controller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import 'package:shop_app/utils/constants/enums.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VariationController());
    return Obx(
      () => Column(
        children: [
          if (controller.selectedVariation.value.id.isNotEmpty)
            RoundedContainer(
              padding: EdgeInsets.all(16),
              backgroundColor: const Color.fromARGB(255, 234, 230, 230),
              borderColor: Colors.black,
              child: Column(
                children: [
                  // Mô tả
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BrandTitleText(title: 'Mẫu khác: ', brandTextSize: TextSizes.large),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              BrandTitleText(title: 'Giá: '),
                              SizedBox(width: 0),
                              if (controller.selectedVariation.value.salePrice > 0)
                                ProductPriceText(
                                  price: controller.selectedVariation.value.price,
                                  lineThrough: true,
                                  isLarge: false,
                                ),
                              SizedBox(width: 10),
                              // Giá sale
                              ProductPriceText(price: controller.getVariationPrice()),
                            ],
                          ),
                          Row(
                            children: [
                              BrandTitleText(title: 'Trạng thái: '),
                              SizedBox(width: 2),
                              Text(controller.variationStockStatus.value),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ReadMoreText(
                    style: TextStyle(color: Colors.black),
                    trimCollapsedText: 'Đọc thêm',
                    trimExpandedText: 'Thu gọn',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    moreStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    lessStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    controller.selectedVariation.value.description ?? '',
                  ),
                ],
              ),
            ),
          SizedBox(height: 12),
          // Màu và size
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: product.productAttributes!
                .map(
                  (attribute) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeading(
                        textTitle: attribute.name ?? '',
                        showActionButton: false,
                        textColor: THelperFunctions.isDarkMode(context)
                            ? Colors.white
                            : Colors.black,
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => Wrap(
                          spacing: 8,
                          children: attribute.values!.map((attributeValue) {
                            final isSelected =
                                controller.selectedAttributes[attribute.name] == attributeValue;
                            final available = controller
                                .getAttributesAvailabilityInVariation(
                                  product.productVariations!,
                                  attribute.name!,
                                )!
                                .contains(attributeValue);
                            return ChoiceChipAttribute(
                              text: attributeValue,
                              selected: isSelected,
                              onSelected: available
                                  ? (selected) {
                                      if (selected && available) {
                                        controller.onAttributeSelected(
                                          product,
                                          attribute.name ?? '',
                                          attributeValue,
                                        );
                                      }
                                    }
                                  : null,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
