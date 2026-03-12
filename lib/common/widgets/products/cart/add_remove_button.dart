import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_container.dart';

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularContainer(
          width: 20,
          height: 20,
          backgroundColor: Colors.grey,
          padding: EdgeInsets.all(0),
          onPressed: remove,
          child: Icon(Icons.remove, size: 15),
        ),
        SizedBox(width: 6),
        Text(quantity.toString(), style: TextStyle(fontSize: 16)),
        SizedBox(width: 6),
        CircularContainer(
          width: 20,
          height: 20,
          backgroundColor: Colors.blue,
          padding: EdgeInsets.all(0),
          onPressed: add,
          child: Icon(Icons.add, size: 15),
        ),
      ],
    );
  }
}
