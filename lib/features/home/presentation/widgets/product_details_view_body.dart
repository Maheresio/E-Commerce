import 'package:e_commerce/features/home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';

class ProductDetailsViewBody extends StatelessWidget {
  const ProductDetailsViewBody(this.product, {super.key});

  final ProductEntity product;
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Product Details View Body'));
  }
}
