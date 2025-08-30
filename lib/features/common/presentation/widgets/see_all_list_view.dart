import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../home/domain/entities/product_entity.dart';
import 'see_all_list_view_item.dart';

class SeeAllListView extends StatelessWidget {
  const SeeAllListView({
    super.key,
    required this.data,
    required this.controller,
    this.isLoadingMore = false,
  });
  final List<ProductEntity> data;
  final ScrollController controller;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16),
    child: ListView.separated(
      controller: controller,
      itemBuilder: (context, index) => SeeAllListViewItem(data: data[index]),

      separatorBuilder: (context, index) => const SizedBox(height: 26),

      itemCount: data.length,
    ),
  );
}
