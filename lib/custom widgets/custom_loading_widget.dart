import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingWidget extends StatelessWidget {
  final Color color;
  final double size;
  const CustomLoadingWidget({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(color: color, size: size),
    );
  }
}
