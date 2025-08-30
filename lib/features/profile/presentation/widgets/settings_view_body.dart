import 'settings_header.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = context.color;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            InkWell(
              onTap: () => context.pop(),
              child: const Icon(Icons.arrow_back_ios, size: 28),
            ),
            const SizedBox(height: 30),

            const SettingsHeader(),
            const SizedBox(height: 23),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [
                Text(
                  AppStrings.kPersonalInformation,
                  style: AppStyles.font16BlackSemiBold(context),
                ),

                const TextField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: AppStrings.kFullName),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: AppStrings.kDateOfBirth,
                    hintText: AppStrings.kDateFormatHint,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final String digitsOnly = newValue.text.replaceAll(
                        RegExp(r'[^0-9]'),
                        '',
                      );
                      final StringBuffer buffer = StringBuffer();

                      for (int i = 0; i < digitsOnly.length && i < 8; i++) {
                        buffer.write(digitsOnly[i]);
                        if ((i == 1 || i == 3) && i != digitsOnly.length - 1) {
                          buffer.write('/');
                        }
                      }

                      final int newOffset = buffer.length;
                      return TextEditingValue(
                        text: buffer.toString(),
                        selection: TextSelection.collapsed(offset: newOffset),
                      );
                    }),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 54),
            Column(
              spacing: 20,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.kPassword,
                      style: AppStyles.font16BlackSemiBold(context),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        AppStrings.kChange,
                        style: AppStyles.font14GreyMedium(context),
                      ),
                    ),
                  ],
                ),
                TextField(
                  readOnly: true,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  controller: TextEditingController(text: '********'),
                  decoration: const InputDecoration(
                    labelText: AppStrings.kPassword,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 54),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.kNotifications,
                  style: AppStyles.font16BlackSemiBold(context),
                ),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  value: true,
                  onChanged: (val) {},
                  title: const Text(AppStrings.kSales),
                  activeThumbColor: themeColors.onTertiary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: themeColors.secondary.withValues(
                    alpha: 0.2,
                  ),

                  contentPadding: EdgeInsets.zero,
                  activeTrackColor: themeColors.onTertiary.withValues(
                    alpha: 0.2,
                  ),
                  trackOutlineColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                ),
                SwitchListTile.adaptive(
                  value: false,
                  onChanged: (val) {},
                  title: const Text(AppStrings.kNewArrivals),
                  activeThumbColor: themeColors.onTertiary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: themeColors.secondary.withValues(
                    alpha: 0.2,
                  ),

                  contentPadding: EdgeInsets.zero,
                  activeTrackColor: themeColors.onTertiary.withValues(
                    alpha: 0.2,
                  ),
                  trackOutlineColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                ),
                SwitchListTile.adaptive(
                  value: false,
                  onChanged: (val) {},
                  title: const Text(AppStrings.kDeliveryStatusChanges),
                  activeThumbColor: themeColors.onTertiary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: themeColors.secondary.withValues(
                    alpha: 0.2,
                  ),

                  contentPadding: EdgeInsets.zero,
                  activeTrackColor: themeColors.onTertiary.withValues(
                    alpha: 0.2,
                  ),
                  trackOutlineColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
