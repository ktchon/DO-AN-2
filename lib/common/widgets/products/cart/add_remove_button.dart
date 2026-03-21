import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:shop_app/utils/constants/colors.dart';

class ProductQuantityWithAddRemoveButton extends StatelessWidget {
  const ProductQuantityWithAddRemoveButton({
    super.key,
    this.add,
    this.remove,
    required this.quantity,
  });

  final int quantity;
  final VoidCallback? add, remove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: TColors.grey, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularContainer(
            radius: 6,
            width: 20,
            height: 20,
            backgroundColor: TColors.grey,
            padding: EdgeInsets.all(0),
            onPressed: remove,
            child: Icon(Icons.remove, size: 15),
          ),
          SizedBox(width: 6),
          Text(quantity.toString(), style: TextStyle(fontSize: 16, color: Colors.black)),
          SizedBox(width: 6),
          CircularContainer(
            radius: 6,
            width: 20,
            height: 20,
            backgroundColor: TColors.grey,
            padding: EdgeInsets.all(0),
            onPressed: add,
            child: Icon(Icons.add, size: 15),
          ),
        ],
      ),
    );
  }
}
