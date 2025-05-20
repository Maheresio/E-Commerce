import 'package:e_commerce/core/helpers/extensions/theme_color.extension.dart';
import 'package:flutter/material.dart';

FloatingActionButton addFloatingButton(
  BuildContext context, {
  void Function()? onPressed,
}) {
  return FloatingActionButton(
    shape: const CircleBorder(),
    backgroundColor: context.color.primaryFixed,
    foregroundColor: context.color.onSecondary,
    onPressed: onPressed,
    child: const Icon(Icons.add),
  );
}
