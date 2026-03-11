import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shop_app/features/personalization/controllers/address_controller.dart';
import 'package:shop_app/features/personalization/models/address_model.dart';

class SingleAddress extends StatelessWidget {
  const SingleAddress({super.key, required this.address, required this.onTap});
  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    return Obx(() {
      final selectAddressId = controller.selectedAddress.value.id;
      final selectedAddress = selectAddressId == address.id;
      return InkWell(
        onTap: onTap,
        child: RoundedContainer(
          width: double.infinity,
          backgroundColor: selectedAddress
              ? const Color.fromARGB(255, 166, 238, 203)
              : const Color.fromARGB(255, 234, 230, 230),
          borderColor: Colors.black,
          margin: EdgeInsets.only(bottom: 16),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 5,
                child: Icon(
                  selectedAddress ? Iconsax.tick_circle : null,
                  color: selectedAddress ? Colors.white : null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.black),
                  ),
                  Text(
                    '84+ ${address.phoneNumber}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    address.toString(),
                    softWrap: true,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
