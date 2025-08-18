import '../../../checkout/presentation/widgets/styled_app_bar.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/product_entity.dart';
import '../widgets/product_details_view_body.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView(this.product, {super.key});

  final ProductEntity product;
  @override
  Widget build(BuildContext context)=> Scaffold(
      appBar: styledAppBar(context, title: product.name, icon: Icons.share),
      body: ProductDetailsViewBody(product),
    );
}
