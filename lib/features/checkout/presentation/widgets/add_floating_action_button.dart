import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

FloatingActionButton addFloatingButton(
  BuildContext context, {
  void Function()? onPressed,
}) {
  final themeColors = context.color;
  return FloatingActionButton(
    shape: const CircleBorder(),
    backgroundColor: themeColors.primaryFixed,
    foregroundColor: themeColors.onSecondary,
    onPressed: onPressed,
    child: const Icon(Icons.add),
  );
}
