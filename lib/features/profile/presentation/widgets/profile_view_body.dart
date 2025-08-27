import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/app_strings.dart';
import 'profile_header.dart';
import 'profile_section_title.dart';
import 'profile_list_tile.dart';
import 'profile_list_view.dart';
import 'profile_logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_styles.dart';
import '../controller/profile_provider.dart';
import 'profile_shimmer.dart';

class ProfileViewBody extends ConsumerWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);

    return state.when(
      data: (data) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50),
              const ProfileSectionTitle(title: AppStrings.kMyProfile),
              const SizedBox(height: 24),
              ProfileHeader(
                photoUrl: data.userEntity?.photoUrl,
                name: data.userEntity?.name,
                email: data.userEntity?.email,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ProfileListView(
                  itemCount: data.profileItems.length,
                  itemBuilder:
                      (context, index) => ProfileListTile(
                        title: data.profileItems[index]['title']!,
                        subtitle: data.profileItems[index]['subtitle']!,
                        onTap: () async {
                          switch (index) {
                            case 0:
                              await context.push(AppRouter.kMyOrdersView);
                              break;
                            case 1:
                              await context.push(AppRouter.kShippingAddress);
                              break;
                            case 2:
                              await context.push(AppRouter.kPaymentMethods);
                              break;
                            case 3:
                              // context.push(AppRouter.kNotifications);
                              break;
                            case 4:
                              await context.push(AppRouter.kSettingsView);
                              break;
                            case 5:
                              await showLogoutDialog(context, ref, () async {
                                await ref
                                    .read(profileProvider.notifier)
                                    .logout();
                                if (context.mounted) {
                                  context.go(AppRouter.kLogin);
                                }
                              });
                              break;
                          }
                        },
                      ),
                  separator: Divider(color: Colors.grey.shade200, height: 1.h),
                ),
              ),
            ],
          ),
        );
      },
      error:
          (error, stack) => Center(
            child: Text(
              AppStrings.kErrorLoadingProfile.replaceAll(
                '%s',
                error.toString(),
              ),
              style: AppStyles.font16BlackSemiBold(context),
            ),
          ),
      loading: () => const ProfileViewBodyShimmer(),
    );
  }
}
