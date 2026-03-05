import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/products/product_card_vartical.dart';
import 'package:shop_app/features/shop/models/product_model.dart';

class Sortable extends StatelessWidget {
  const Sortable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField(
          decoration: InputDecoration(prefixIcon: Icon(Icons.filter_list)),
          items: [
            'Giảm giá',
            'Hàng mới',
            'HOT',
            'Giá thấp',
            'Giá cao',
          ].map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
          onChanged: (value) {},
        ),
        SizedBox(height: 28),
        GridLayout(
          itemCount: 6,
          itemBuilder: (_, index) => ProductCardVartical(product: ProductModel.empty()),
        ),
      ],
    );
  }
}
