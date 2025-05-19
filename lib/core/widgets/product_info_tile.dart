import 'package:flutter/material.dart';

import '../utils/app_styles.dart';

class ProductInfoTile extends StatelessWidget {
  const ProductInfoTile({super.key, required this.title, this.onTap});
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),

      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black12)),

      title: Text(title, style: AppStyles.font16BlackRegular),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: onTap,
    );
  }
}

