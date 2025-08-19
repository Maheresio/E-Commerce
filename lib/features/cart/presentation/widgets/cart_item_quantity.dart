import '../../domain/entities/cart_item_entity.dart';
import '../controller/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_styles.dart';

class CartItemQuantity extends ConsumerWidget {
  const CartItemQuantity({super.key, required this.cartItem});
  final CartItemEntity cartItem;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CartController cartController = ref.watch(
      cartControllerProvider(FirebaseAuth.instance.currentUser!.uid).notifier,
    );
    return Row(
      spacing: 16.w,
      children: <Widget>[
        CircularQuantityButton(
          icon: Icons.remove,
          onPressed:
              cartController.isLoading(cartItem.id)
                  ? null
                  : () {
                    cartController.decrementQuantity(cartItem);
                  },
        ),
        Text(
          cartItem.quantity.toString(),
          style: AppStyles.font15BlackSemiBold(context),
        ),

        CircularQuantityButton(
          icon: Icons.add,
          onPressed:
              cartController.isLoading(cartItem.id)
                  ? null
                  : () {
                    cartController.incrementQuantity(cartItem);
                  },
        ),
      ],
    );
  }
}

class CircularQuantityButton extends StatelessWidget {
  const CircularQuantityButton({super.key, required this.icon, this.onPressed});

  final IconData icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final themeColors = context.color;
    return DecoratedBox(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.3),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: IconButton(
      padding: EdgeInsets.all(8.w),
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: WidgetStatePropertyAll(
          themeColors.primary.withValues(alpha: 0.2),
        ),
      ),
      splashColor: themeColors.primary.withValues(alpha: 0.2),

      icon: Icon(icon),
      onPressed: onPressed,
    ),
  );
  }
}
