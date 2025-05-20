import 'package:flutter/material.dart';

import '../../../../core/helpers/extensions/theme_color.extension.dart';
import '../../../../core/utils/app_styles.dart';

class ShippingCheckbox extends StatefulWidget {
  const ShippingCheckbox({
    super.key,
    this.isChecked = false,
    required this.text,
  });

  final String text;
  final bool isChecked;
  @override
  State<ShippingCheckbox> createState() => _ShippingCheckboxState();
}

class _ShippingCheckboxState extends State<ShippingCheckbox> {
  late bool isChecked;
  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile.adaptive(
      value: isChecked,
      onChanged: (val) {
        setState(() {
          isChecked = val!;
        });
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(widget.text, style: AppStyles.font14BlackMedium),
      activeColor: context.color.onPrimary,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      checkColor: context.color.onSecondary,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      checkboxScaleFactor: 1.2,
      visualDensity: VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
    );
  }
}
