import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StyledLoading extends StatelessWidget {
  const StyledLoading({super.key, this.size = 50, this.color});
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: color ?? Theme.of(context).colorScheme.primary,
        size: size,
      ),
    );
  }
}
