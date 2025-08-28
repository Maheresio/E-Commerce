import '../../../profile/presentation/controller/profile_provider.dart';
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
  const ShippingAddressCard({
    super.key,
    this.isEditable = false,
    required this.address,
  });

  final bool isEditable;
  final ShippingAddressEntity address;

  @override
  Widget build(BuildContext context) {
    // if not editable, just show the card (no swipe)
    if (!isEditable) return _CardBody(address: address, isEditable: isEditable);
    return Consumer(
      builder: (context, ref, _) {
        return Dismissible(
          key: Key('address_${address.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: AlignmentDirectional.centerEnd,
            padding: EdgeInsets.only(right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, color: Colors.white, size: 22.sp),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.kRemove,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          confirmDismiss: (_) async {
            return await _showDeleteAddressDialog(context, address);
          },
          onDismissed: (_) async {
            // call your provider to delete the address
            await ref
                .read(shippingAddressNotifierProvider.notifier)
                .deleteAddress(
                  address.id,
                ); // <-- ensure this exists in your notifier
            // optionally refresh the list:
            await ref.read(shippingAddressNotifierProvider.notifier).refresh();
            // If you also want to refresh the profile counters when inside profile:
            ref.invalidate(profileProvider);
          },
          child: _CardBody(address: address, isEditable: isEditable),
        );
      },
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({required this.address, required this.isEditable});

  final ShippingAddressEntity address;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final theme = context.color;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.onSecondary,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.12),
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
            // header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  address.name,
                  style: AppStyles.font14BlackSemiBold(context),
                ),
                Consumer(
                  builder: (context, ref, _) {
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

            // address text
            Opacity(
              opacity: 0.8,
              child: Text(
                '${address.street}\n${address.city}, ${address.state} ${address.zipCode}',
                style: AppStyles.font14BlackMedium(context),
              ),
            ),

            // default checkbox
            if (isEditable)
              Consumer(
                builder: (context, ref, _) {
                  return StyledCheckbox(
                    text: AppStrings.kUseAsShippingAddress,
                    isChecked: address.isDefault,
                    onChanged: (_) {
                      ref
                          .read(shippingAddressNotifierProvider.notifier)
                          .setDefault(address.id);
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _showDeleteAddressDialog(
  BuildContext context,
  ShippingAddressEntity address,
) async {
  final theme = Theme.of(context);
  final bool? result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          title: Row(
            children: <Widget>[
              const Icon(Icons.location_on_outlined, color: Colors.redAccent),
              const SizedBox(width: 8),
              Text(
                AppStrings.kRemoveShippingAddress, // add this in strings
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Text(
              AppStrings
                  .kRemoveShippingAddressConfirmation, // add this in strings
              style: AppStyles.font12GreyMedium(context),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(false),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                    child: Text(
                      AppStrings.kCancel,
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      AppStrings.kRemove,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
  );

  return result ?? false;
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
