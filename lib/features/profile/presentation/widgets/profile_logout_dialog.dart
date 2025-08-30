import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

Future<void> showLogoutDialog(
  BuildContext context,
  WidgetRef ref,
  Future<void> Function() onLogout,
) async {
  final theme = Theme.of(context);
  bool _isLoading = false;

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
          actionsPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          title: Row(
            children: <Widget>[
              const Icon(Icons.logout, color: Colors.redAccent),
              const SizedBox(width: 8),
              Text(
                AppStrings.kLogoutTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Text(
              AppStrings.kLogoutConfirmation,
              style: AppStyles.font12GreyMedium(context),
            ),
          ),
          actions: <Widget>[
            // Give AlertDialog a single full-width child so it doesn't ask for intrinsics
            SizedBox(
              width: double.infinity,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      // Cancel
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: SizedBox(
                          height: 44,
                          child: OutlinedButton(
                            onPressed: () => context.pop(false),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            child: Text(
                              AppStrings.kCancelButton,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Logout
                      StatefulBuilder(
                        builder: (context, setState) {
                          return SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed:
                                  _isLoading
                                      ? null
                                      : () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        context.pop(true);
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                AppStrings.kLogoutButton,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
  );

  if (result == true) {
    await onLogout();
  }
}
