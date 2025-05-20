import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'shipping_address_card.dart';

class ShippingAddressViewBody extends StatelessWidget {
  const ShippingAddressViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 35),
      child: ListView.separated(
        itemBuilder: (_, index) => ShippingAddressCard(hasCheckBox: true),
        itemCount: 3,
        separatorBuilder: (_, index) => SizedBox(height: 24),
      ),
    );
  }
}
