import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_route_constants.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../controller/profile_provider.dart';
import 'profile_header.dart';
import 'profile_list_tile.dart';
import 'profile_list_view.dart';
import 'profile_logout_dialog.dart';
import 'profile_section_title.dart';
import 'profile_shimmer.dart';

class ProfileViewBody extends ConsumerWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final horizontalPadding = AppConstants.horizontalPadding16;

    return state.when(
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: const ProfileSectionTitle(title: AppStrings.kMyProfile),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: ProfileHeader(
                photoUrl: data.userEntity?.photoUrl,
                name: data.userEntity?.name,
                email: data.userEntity?.email,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ProfileListView(
                itemCount: data.profileItems.length,
                itemBuilder:
                    (context, index) => ProfileListTile(
                      title: data.profileItems[index]['title']!,
                      subtitle: data.profileItems[index]['subtitle']!,
                      padding: horizontalPadding,
                      onTap: () async {
                        switch (index) {
                          case 0:
                            await context.push(AppRoutes.myOrders);
                            break;
                          case 1:
                            await context.push(AppRoutes.shippingAddress);
                            break;
                          case 2:
                            await context.push(AppRoutes.paymentMethods);
                            break;
                          case 3:
                            // context.push(AppRoutes.kNotifications);
                            break;
                          case 4:
                            await context.push(AppRoutes.settings);
                            break;
                          case 5:
                            await showLogoutDialog(context, ref, () async {
                              await ref.read(profileProvider.notifier).logout();
                              if (context.mounted) {
                                context.go(AppRoutes.login);
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
