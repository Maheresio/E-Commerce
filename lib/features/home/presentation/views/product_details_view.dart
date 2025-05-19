import '../../../../core/helpers/extensions/theme_color.extension.dart';
import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/product_entity.dart';
import '../widgets/product_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView(this.product, {super.key});

  final ProductEntity product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: ProductDetailsViewBody(product),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      surfaceTintColor: context.color.onSecondary,
      title: Text(product.title, style: AppStyles.font18BlackSemiBold),
      centerTitle: true,
      backgroundColor: context.color.onSecondary,
      elevation: 2,
      automaticallyImplyLeading: false,
      shadowColor: context.color.onSecondary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => context.pop(),
      ),
      actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {})],
    );
  }
}
