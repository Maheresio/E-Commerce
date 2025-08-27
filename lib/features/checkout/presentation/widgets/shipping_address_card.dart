import '../../domain/entities/shipping_address_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../controller/shipping_address/shipping_address_providers.dart';
import 'shipping_check_box.dart';

class ShippingAddressCard extends StatelessWidget {
  const ShippingAddressCard({super.key, this.isEditable = false, this.address});

  final bool isEditable;
  final ShippingAddressEntity? address;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.color.onSecondary,
      borderRadius: BorderRadius.circular(8),

      boxShadow: [
        BoxShadow(
          color: context.color.primary.withValues(alpha: 0.12),
          spreadRadius: 1.5,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 18.h),
      child: Column(
        spacing: 7,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                address!.name,
                style: AppStyles.font14BlackSemiBold(context),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return InkWell(
                    onTap: () {
                      isEditable
                          ? context.push(
                            AppRouter.kAddShippingAddress,
                            extra: address,
                          )
                          : context.push(AppRouter.kShippingAddress);
                    },
                    child: Text(
                      isEditable ? AppStrings.kEdit : AppStrings.kChange,
                      style: AppStyles.font14PrimaryMedium(context),
                    ),
                  );
                },
              ),
            ],
          ),

          Opacity(
            opacity: 0.8,
            child: Text(
              '${address!.street}\n${address!.city}, ${address!.state} ${address!.zipCode}',
              style: AppStyles.font14BlackMedium(context),
            ),
          ),

          //Todo: Need to make sure it can be changed
          if (isEditable)
            Consumer(
              builder: (context, ref, child) {
                return StyledCheckbox(
                  text: AppStrings.kUseAsShippingAddress,
                  isChecked: address!.isDefault,
                  onChanged: (_) {
                    ref
                        .read(shippingAddressNotifierProvider.notifier)
                        .setDefault(address!.id);
                  },
                );
              },
            ),
        ],
      ),
    ),
  );
}

class NoShippingAddressWidget extends StatelessWidget {
  const NoShippingAddressWidget({super.key, required this.onAddAddress});

  final VoidCallback onAddAddress;

  @override
  Widget build(BuildContext context) {
    final themeColors = context.color;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: themeColors.onSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeColors.primary.withValues(alpha: 0.12),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: themeColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.add_location_alt_outlined,
                size: 20.sp,
                color: themeColors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    AppStrings.kNoShippingAddress,
                    style: AppStyles.font16BlackSemiBold(context),
                  ),
                  Text(
                    AppStrings.kAddYourDeliveryAddress,
                    style: AppStyles.font14BlackMedium(context).copyWith(
                      color: themeColors.primary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onAddAddress,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: themeColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  AppStrings.kAdd,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
