import 'package:flutter/material.dart';

class ProductTitleText extends StatelessWidget {
  const ProductTitleText({
    required this.text,
    this.textAlign = TextAlign.left,
    this.smallSize = true,
    this.maxLines = 2,
    super.key,
  });

  final String text;
  final TextAlign? textAlign;
  final bool smallSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: smallSize
          ? Theme.of(context).textTheme.labelSmall
          : Theme.of(context).textTheme.labelLarge,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
