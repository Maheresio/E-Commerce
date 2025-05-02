import 'package:e_commerce/core/helpers/extensions/theme_color.extension.dart';
import 'package:e_commerce/core/utils/app_images.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListViewItem extends StatelessWidget {
  const ListViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        height: 320,
        width: 170,
        child: Stack(
          children: [
            ProductItem(),
            Positioned(top: 8, left: 8, child: DiscountText()),
            Positioned(right: 0, bottom: 100, child: FavoriteIcon()),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImage(),
        SizedBox(height: 7),
        RatingAndReview(),
        SizedBox(height: 6),
        ProductInfo(),
        SizedBox(height: 3),
        ProductPrice(),
      ],
    );
  }
}

class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Apple Watch Series 7', style: AppStyles.font11GreyMedium),
        SizedBox(height: 5),
        Text('Evening Dress', style: AppStyles.font16BlackSemiBold),
      ],
    );
  }
}

class ProductPrice extends StatelessWidget {
  const ProductPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '15\$ ',
        style: AppStyles.font14GreyMedium.copyWith(
          decoration: TextDecoration.lineThrough,
        ),
        children: [
          TextSpan(text: '12\$', style: AppStyles.font14PrimaryMedium),
        ],
      ),
    );
  }
}

class RatingAndReview extends StatelessWidget {
  const RatingAndReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(Icons.star, color: Colors.amber, size: 16);
          }),
        ),
        SizedBox(width: 4),
        Text('(10)', style: AppStyles.font11BlackRegular),
      ],
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,

      child: Image.asset(AppImages.photo, fit: BoxFit.cover),
    );
  }
}

class DiscountText extends StatelessWidget {
  const DiscountText({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.color.primary,
          borderRadius: BorderRadius.circular(29),
        ),
        child: Center(
          child: Text(
            '-20%',
            style: AppStyles.font11WhiteSemiBold,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({super.key});

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.onSecondary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.favorite_border, color: context.color.secondary),
      ),
    );
  }
}
