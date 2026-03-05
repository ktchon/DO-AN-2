import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shop_app/features/personalization/screens/address/add_new_address.dart';
import 'package:shop_app/features/personalization/screens/address/widgets/single_address.dart';
import 'package:shop_app/utils/constants/colors.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => Get.to(AddNewAddress()),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Địa chỉ',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SingleAddress(selectedAddress: true,),
              SingleAddress(selectedAddress: false,),
            ],
          ),
        ),
      ),
    );
  }
}

