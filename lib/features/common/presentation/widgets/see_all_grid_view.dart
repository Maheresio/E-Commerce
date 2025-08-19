import 'package:e_commerce/core/widgets/styled_loading.dart';

import '../../../home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../home/presentation/widgets/home_list_view_item.dart';

class SeeAllGridView extends StatelessWidget {
  const SeeAllGridView({
    super.key,
    required this.data,
    required this.controller,
    this.isLoadingMore = false,
    this.favoriteIcon = true,
  });
  final List<ProductEntity> data;
  final ScrollController controller;
  final bool isLoadingMore;
  final bool favoriteIcon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w, top: 16.h),
    child: Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: controller,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: .52,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
            ),
            itemBuilder:
                (context, index) =>
                    HomeListViewItem(data[index], favoriteIcon: favoriteIcon),
            itemCount: data.length,
          ),
        ),
        if (isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: StyledLoading(),
          ),
      ],
    ),
  );
}
