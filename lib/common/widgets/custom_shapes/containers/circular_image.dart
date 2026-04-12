import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/shimmer/shimmer.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor, 
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = 10,
    this.isNetworkImage = false,
    this.border,
    this.borderRadius = 100,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;
  final BoxBorder? border;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? Colors.black : Colors.white),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius), 
        child: isNetworkImage
            ? CachedNetworkImage(
                imageUrl: image,
                fit: fit,
                color: overlayColor,  
                colorBlendMode: overlayColor != null ? BlendMode.srcIn : null,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CShimmerEffect(width: 55, height: 55),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : Image(
                fit: fit,
                image: AssetImage(image),
                color: overlayColor,
                colorBlendMode: overlayColor != null ? BlendMode.srcIn : null,
              ),
      ),
    );
  }
}
