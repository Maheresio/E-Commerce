import 'package:flutter/material.dart';

class ProfileListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget? separator;
  const ProfileListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: itemBuilder,
      separatorBuilder:
          (context, index) => separator ?? const Divider(height: 1),
      itemCount: itemCount,
    );
  }
}
