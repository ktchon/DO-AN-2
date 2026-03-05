import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/appbar/appbar.dart';
import 'package:shop_app/features/personalization/controllers/profile_controller/update_name_controller.dart';
import 'package:shop_app/utils/constants/sizes.dart';
import 'package:shop_app/utils/validators/validator.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());

    return Scaffold(
      // Custom Appbar
      appBar: Appbar(
        showBackArrow: true,
        title: Text('Thay đổi tên', style: Theme.of(context).textTheme.headlineSmall),
      ),

      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(
              'Sử dụng tên thật để dễ dàng xác minh. Tên này sẽ xuất hiện trên nhiều trang khác nhau.',
              style: Theme.of(context).textTheme.labelMedium,
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Text field and Button
            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.firstName,
                    validator: (value) => CValidator.validateEmptyText('Tên', value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: 'Tên',
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  TextFormField(
                    controller: controller.lastName,
                    validator: (value) => CValidator.validateEmptyText('Họ', value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: 'Họ',
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateUserName(),
                child: const Text('Lưu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
