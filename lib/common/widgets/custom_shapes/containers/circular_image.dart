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
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        // If image background color is null then switch it to light and dark mode color design.
        color:
            backgroundColor ?? (THelperFunctions.isDarkMode(context) ? Colors.black : Colors.white),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
              ? CachedNetworkImage(
                  fit: fit,
                  color: overlayColor,
                  imageUrl: image, // Đây là URL của ảnh network
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const CShimmerEffect(
                        width: 55,
                        height: 55,
                      ), // Loading: shimmer effect tùy chỉnh (rất đẹp cho UX)
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error), // Lỗi: icon error mặc định
                  // errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.red, size: 40), // Nếu muốn tùy chỉnh hơn
                )
              : Image(
                  fit: fit,
                  image: AssetImage(
                    image,
                  ), // image lúc này là path asset, ví dụ 'assets/images/placeholder.png'
                  color: overlayColor,
                ),
        ),
      ),
    );
  }
}
