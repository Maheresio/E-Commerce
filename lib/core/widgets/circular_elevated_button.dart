import 'package:e_commerce/core/helpers/extensions/theme_color.extension.dart';
import 'package:flutter/material.dart';

class CircularElevatedButton extends StatelessWidget {
  const CircularElevatedButton({
    super.key,
    required this.text,
    this.color,
    this.borderColor = Colors.transparent,
    this.onPressed,
  });
  final String text;
  final Color? color;
  final Color borderColor;

  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color ?? context.color.primary),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(color: borderColor, width: 2.0),
          ),
        ),
      ),
      child: Text(text),
    );
  }
}
