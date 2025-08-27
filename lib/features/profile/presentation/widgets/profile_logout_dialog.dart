import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/app_strings.dart';

Future<void> showLogoutDialog(
  BuildContext context,
  WidgetRef ref,
  Future<void> Function() onLogout,
) async {
  final theme = Theme.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
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
          content: Text(
            AppStrings.kLogoutConfirmation,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide(color: theme.colorScheme.primary),
              ),
              child: Text(
                AppStrings.kCancelButton,
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
            Consumer(
              builder:
                  (context, ref, child) => ElevatedButton(
                    onPressed: () async {
                      await onLogout();
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
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
            ),
          ],
        ),
  );
  if (confirmed == true) {
    await onLogout();
  }
}
