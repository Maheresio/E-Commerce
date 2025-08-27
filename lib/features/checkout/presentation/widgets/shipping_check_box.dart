import 'package:flutter/material.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_styles.dart';

class StyledCheckbox extends StatelessWidget {
  const StyledCheckbox({
    super.key,
    this.isChecked = false,
    required this.text,
    this.onChanged,
  });

  final String text;
  final bool isChecked;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final themeColors = context.color;
    return CheckboxListTile.adaptive(
      value: isChecked,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(text, style: AppStyles.font14BlackMedium(context)),
      activeColor: themeColors.onPrimary,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      checkColor: themeColors.onSecondary,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

      checkboxScaleFactor: 1.2,
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
    );
  }
}
