import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/product_entity.dart';

class ProductDetailsImageSlider extends StatelessWidget {
  const ProductDetailsImageSlider({
    super.key,
    required this.product,
    this.selectedColor = 'black',
  });

  final ProductEntity product;
  final String selectedColor;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        enableInfiniteScroll: false,
        padEnds: false,
        viewportFraction: .8,
        height: 413.h,
      ),
      items:
          (product.imageUrls[selectedColor] ?? []).map((element) {
            return Padding(
              padding: EdgeInsetsDirectional.only(end: 8.w),
              child: Image.network(
                element,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
    );
  }
}
