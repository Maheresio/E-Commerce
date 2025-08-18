import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

void openStyledSnackBar(
  BuildContext context, {
  required String text,
  SnackBarType type = SnackBarType.info,
}) {
  Color backgroundColor;
  IconData icon;
  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      icon = Icons.error;
      break;
    default:
      backgroundColor = Colors.blue;
      icon = Icons.info;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,

      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Colors.white),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: AppStyles.font14WhiteSemiBold(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 2500),
    ),
  );
}
