import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/responsive/responsive_value.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/cached_image_widget.dart';
import '../../domain/entities/product_entity.dart';
import '../controller/product_details_provider.dart';

class ProductDetailsImageSlider extends ConsumerStatefulWidget {
  const ProductDetailsImageSlider({super.key, required this.product});

  final ProductEntity product;

  @override
  ConsumerState<ProductDetailsImageSlider> createState() =>
      _ProductDetailsImageSliderState();
}

class _ProductDetailsImageSliderState
    extends ConsumerState<ProductDetailsImageSlider> {

  List<String> _currentImages() {
    final selection = ref.watch(productSelectionProvider);
    final selectedColor =
        selection.color == AppStrings.kColor
            ? widget.product.colors.first
            : selection.color;
    return widget.product.imageUrls[selectedColor]!;
  }

  @override
  Widget build(BuildContext context) {
    final images = _currentImages();

    return CarouselSlider.builder(
      itemCount: images.length,
      options: CarouselOptions(
        padEnds: false,
        viewportFraction: context.responsive(mobile: 1, tablet: .5),
        autoPlay: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        autoPlayCurve: Curves.linear,
        pauseAutoPlayOnTouch: true,
        height: context.responsive(mobile: 413.h, tablet: 500.h),
        initialPage: 0, // <-- always start at index 0
        enableInfiniteScroll: images.length > 1,
      ),
      itemBuilder: (context, i, realIdx) {
        final image = CachedImageWidget(imgUrl: images[i]);
        return image;
      },
    );
  }
}
