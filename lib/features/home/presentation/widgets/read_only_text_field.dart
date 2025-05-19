import 'package:e_commerce/core/helpers/extensions/theme_color.extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_styles.dart';

class ReadOnlyTextFormField extends StatelessWidget {
  const ReadOnlyTextFormField({super.key, required this.value, this.onTap});

  final String value;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      enableInteractiveSelection: false,
      initialValue: value,
      style: AppStyles.font14BlackMedium,
      readOnly: true,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
        filled: true,
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.color.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: context.color.onPrimary.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
