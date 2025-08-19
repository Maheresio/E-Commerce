import '../../../../core/utils/app_strings.dart';
import '../../../checkout/presentation/widgets/styled_app_bar.dart';
import '../widgets/category_view_body.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({
    super.key,
    required this.index,
    required this.genderList,
  });

  final Map<String, dynamic> genderList;
  final int index;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: styledAppBar(context, title: AppStrings.kCategories),
    body: CategoryViewBody(genderList: genderList, index: index),
  );
}
