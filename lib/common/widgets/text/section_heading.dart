import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.textTitle,
    this.buttonTitle = 'Tất cả',
    this.textColor,
    this.showActionButton = true,
    this.onPressed,
    super.key,
    this.style = false,
  });

  final String textTitle, buttonTitle;
  final Color? textColor;
  final bool showActionButton;
  final void Function()? onPressed;
  final bool style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          textTitle,
          style: style
              ? Theme.of(context).textTheme.titleMedium!.apply(color: textColor)
              : Theme.of(context).textTheme.headlineSmall!.apply(color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton) TextButton(onPressed: onPressed, child: Text(buttonTitle)),
      ],
    );
  }
}
