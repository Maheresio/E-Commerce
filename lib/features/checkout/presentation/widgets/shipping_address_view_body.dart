import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../controller/shipping_address/shipping_address_providers.dart';
import 'shipping_address_card.dart';
import 'shipping_address_shimmer.dart';

class ShippingAddressViewBody extends ConsumerWidget {
  const ShippingAddressViewBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ShippingAddressEntity>> state = ref.watch(
      shippingAddressNotifierProvider,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 35),
      child: state.when(
        data: (List<ShippingAddressEntity> addresses) {
          if (addresses.isEmpty) {
            return Center(
              child: Text(
                AppStrings.kNoShippingAddressesAvailable,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            );
          }
          return ListView.separated(
            itemCount: addresses.length,
            itemBuilder: (BuildContext context, int index) {
              final ShippingAddressEntity address = addresses[index];
              return ShippingAddressCard(address: address, isEditable: true);
            },
            separatorBuilder:
                (BuildContext context, int index) => SizedBox(height: 24.h),
          );
        },
        loading: () => const ShippingAddressListShimmer(),
        error:
            (Object error, StackTrace stackTrace) => Center(
              child: Text('${AppStrings.kErrorLoadingAddresses}: $error'),
            ),
      ),
    );
  }
}
