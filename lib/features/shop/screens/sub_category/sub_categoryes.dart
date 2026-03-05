import 'package:flutter/material.dart';
import 'package:shop_app/common/images/banner_images.dart';
import 'package:shop_app/common/widgets/products/product_card_horizontal.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/utils/constants/colors.dart';

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Sports',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Bannner khuyến mãi
              BannerImage(imageUrl: 'assets/banner/banner_3.png'),
              SizedBox(height: 28),
              // Thể loại
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeading(textTitle: 'Giày chạy bộ', style: true, onPressed: () {}),
                  SizedBox(height: 6),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      itemCount: 6,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => ProductCardHorizontal(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
