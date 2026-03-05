import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductPriceText extends StatelessWidget {
  const ProductPriceText({
    required this.price,
    this.currencySign = 'đ',
    this.isLarge = true,
    this.lineThrough = false,
    this.maxLines = 1,
    super.key,
  });

  final num price;
  final String currencySign;
  final bool isLarge;
  final bool lineThrough;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    // Format theo chuẩn Việt Nam
    final formattedPrice = NumberFormat('#,###', 'vi_VN').format(price);

    return Text(
      '$formattedPrice$currencySign',
      style: isLarge
          ? Theme.of(context).textTheme.headlineMedium!.apply(
              color: Colors.red,
              decoration: lineThrough ? TextDecoration.lineThrough : null,
            )
          : Theme.of(context).textTheme.titleLarge!.apply(
              color: Colors.grey,
              decoration: lineThrough ? TextDecoration.lineThrough : null,
            ),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
