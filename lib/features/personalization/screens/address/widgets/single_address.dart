import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/rounded_container.dart';

class SingleAddress extends StatelessWidget {
  const SingleAddress({super.key, required this.selectedAddress});

  final bool selectedAddress;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
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
                'Khuong Chon',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.black),
              ),
              Text(
                '84+ 0904337370',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'Khu vực Long Thạnh 2, P. Thốt Nốt, TP. Cần Thơ',
                softWrap: true,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
