import 'package:flutter/material.dart';

class CartCounterIcon extends StatelessWidget {
  const CartCounterIcon({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    // final dark = THelperFunctions.isDarkMode(context);
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28),
        ),
        Positioned(
          right: 2,
          top: 2,
          child: Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(100)),
            child: Center(
              child: Text(
                '3',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.apply(color: Colors.white, fontSizeFactor: 0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
