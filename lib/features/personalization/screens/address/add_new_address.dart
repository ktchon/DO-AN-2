import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/features/personalization/controllers/address_controller.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/validators/validator.dart';

class AddNewAddress extends StatelessWidget {
  const AddNewAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // màu icon back
        ),
        title: Text(
          'Thêm địa chỉ',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: controller.addressFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller.name,
                  validator: (value) => CValidator.validateEmptyText('Tên', value),
                  decoration: InputDecoration(labelText: 'Tên', prefixIcon: Icon(Icons.person)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.phoneNumber,
                  validator: CValidator.validatePhoneNumber,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.street,
                        validator: (value) => CValidator.validateEmptyText('Đường', value),
                        decoration: InputDecoration(
                          labelText: 'Đường',
                          prefixIcon: Icon(Icons.streetview),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: controller.postalCode,
                        validator: (value) => CValidator.validateEmptyText('Mã bưu chính', value),
                        decoration: InputDecoration(
                          labelText: 'Mã bưu chính',
                          prefixIcon: Icon(Icons.local_post_office),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.city,
                        validator: (value) => CValidator.validateEmptyText('Thành phố', value),
                        decoration: InputDecoration(
                          labelText: 'Thành Phố',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: controller.state,
                        validator: (value) => CValidator.validateEmptyText('State', value),
                        decoration: InputDecoration(
                          labelText: 'State',
                          prefixIcon: Icon(Iconsax.activity),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.country,
                  validator: (value) => CValidator.validateEmptyText('Quốc gia', value),
                  decoration: InputDecoration(
                    labelText: 'Quốc gia',
                    prefixIcon: Icon(Icons.public),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.addNewAddress(),
                    child: Text('Lưu'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
