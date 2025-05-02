import 'package:flutter/material.dart';

import '../../../../../core/helpers/extensions/theme_color.extension.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  final void Function()? onPressed;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed:
            isLoading
                ? null
                : () {

                  FocusManager.instance.primaryFocus?.unfocus();
                  if (onPressed != null) {
                    onPressed!();
                  }
                },

        child: Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: context.color.onSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
