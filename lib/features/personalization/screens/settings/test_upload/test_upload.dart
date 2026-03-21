import 'package:flutter/material.dart';
import 'package:shop_app/features/personalization/screens/settings/test_upload/covert.dart';
import 'package:shop_app/features/personalization/screens/settings/test_upload/insert_data_coupon.dart';
import 'package:shop_app/features/personalization/screens/settings/test_upload/insert_data_test.dart';
import 'package:shop_app/features/personalization/screens/settings/test_upload/insert_date_category.dart';

class TestUpload extends StatelessWidget {
  const TestUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tải dữ liệu')),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: insertSampleProducts, child: Text('Tải lên sản phẩm')),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: insertSampleCategories,
              child: Text('Tải lên danh mục'),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: migrateProductSearchNames,
              child: Text('Thêm SearchNames'),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: insertSampleCoupons, child: Text('Thêm Coupons')),
          ),
        ],
      ),
    );
  }
}
