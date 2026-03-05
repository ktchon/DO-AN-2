import 'package:flutter/material.dart';
import 'package:shop_app/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:shop_app/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:shop_app/utils/constants/colors.dart';

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgesWidget(
      child: Container(
        padding: EdgeInsets.only(bottom: 0),
        color: TColors.primary,
        child: Stack(
          children: [
            Positioned(
              top: -200,
              right: -200,
              child: CircularContainer(backgroundColor: Colors.white.withOpacity(0.1)),
            ),
            Positioned(
              bottom: -230,
              left: -230,
              child: CircularContainer(backgroundColor: Colors.white.withOpacity(0.1)),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
