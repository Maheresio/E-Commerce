import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
 ColorScheme get color => Theme.of(this).colorScheme;
}