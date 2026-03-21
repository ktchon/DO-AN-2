import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/text/section_heading.dart';
import 'package:shop_app/features/personalization/controllers/address_controller.dart';

class BillinngAddressSection extends StatelessWidget {
  const BillinngAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(
          textTitle: 'Địa chỉ giao hàng',
          style: true,
          showActionButton: true,
          onPressed: () => addressController.selectNewAddressPopup(context),
        ),
        SizedBox(height: 5),
        Obx(
          () => addressController.selectedAddress.value.id.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.user),
                        SizedBox(width: 8),
                        Text(addressController.selectedAddress.value.name),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 8),
                        Text('+84 ${addressController.selectedAddress.value.phoneNumber}'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_pin),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            addressController.selectedAddress.toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text('Vui lòng thêm địa chỉ giao hàng', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
