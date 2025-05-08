import 'package:e_commerce/features/home/domain/entities/product_entity.dart';
import 'package:e_commerce/features/home/presentation/widgets/product_details_view_body.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView(this.product, {super.key});

  final ProductEntity product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProductDetailsViewBody(product));
  }
}
