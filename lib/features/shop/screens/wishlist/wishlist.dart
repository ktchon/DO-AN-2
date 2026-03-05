import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shop_app/common/widgets/icons/circular_icon.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/products/product_card_vartical.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/features/shop/screens/home/home.dart';
import 'package:shop_app/utils/constants/colors.dart';

class FavouriteScrenn extends StatelessWidget {
  const FavouriteScrenn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        backgroundColor: TColors.primary,
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        actions: [
          CircularIcon(
            backgroundColor: TColors.primary,
            icon: Icons.add,
            onPressed: () => Get.to(() => HomeScreen()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: GridLayout(
            itemCount: 6,
            itemBuilder: (_, index) => ProductCardVartical(product: ProductModel.empty()),
          ),
        ),
      ),
    );
  }
}
