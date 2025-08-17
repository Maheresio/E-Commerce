import '../utils/app_styles.dart';

import '../helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class CircularElevatedButton extends StatelessWidget {
  const CircularElevatedButton({
    super.key,
    required this.text,
    this.color,
    this.borderColor = Colors.transparent,
    this.onPressed,
    this.textColor,
    this.borderWidth = 2.0,
  });
  final String text;
  final Color? color;
  final Color borderColor;
  final Color? textColor;
  final double borderWidth;

  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) => ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color ?? context.color.primary),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(color: borderColor, width: borderWidth),
          ),
        ),
      ),
      child: FittedBox(
        child: Text(
          text,
          style: AppStyles.font16WhiteMedium(
            context,
          ).copyWith(color: textColor, letterSpacing: 1),
        ),
      ),
    );
}
