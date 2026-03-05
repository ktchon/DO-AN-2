import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/sortable/sortable.dart';
import 'package:shop_app/utils/constants/colors.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Tất cả sản phẩm',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(20), child: Sortable()),
      ),
    );
  }
}
