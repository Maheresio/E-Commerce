import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/shimmer.dart';

class ProfileViewBodyShimmer extends StatelessWidget {
  const ProfileViewBodyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50),
          // Section Title Shimmer - "My Profile"
          ProfileSectionTitleShimmer(),
          SizedBox(height: 24),
          // Profile Header Shimmer
          ProfileHeaderShimmer(),
          SizedBox(height: 30),
          // Profile List Shimmer
          Expanded(child: ProfileListViewShimmer()),
        ],
      ),
    );
  }
}

class ProfileSectionTitleShimmer extends StatelessWidget {
  const ProfileSectionTitleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: ShimmerContainer(
        width: 140.w, // Width for "My Profile" text
        height: 38.h, // Height for font34 text
        borderRadius: 6,
      ),
    );
  }
}

class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Circle Avatar Shimmer
        ShimmerWidget(
          child: Container(
            width: 70.r, // radius: 35.r * 2
            height: 70.r,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        // Name and Email Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Name Shimmer
            ShimmerWidget(
              child: ShimmerContainer(
                width: 120.w, // Typical name length
                height: 20.h, // Height for font18 text
                borderRadius: 4,
              ),
            ),
            SizedBox(height: 4.h), // Small gap between name and email
            // Email Shimmer
            ShimmerWidget(
              child: ShimmerContainer(
                width: 160.w, // Typical email length
                height: 16.h, // Height for font14 text
                borderRadius: 4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProfileListViewShimmer extends StatelessWidget {
  const ProfileListViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 6, // Show 6 shimmer items (typical profile menu items)
      separatorBuilder:
          (context, index) => Divider(color: Colors.grey.shade200, height: 1.h),
      itemBuilder: (context, index) => const ProfileListTileShimmer(),
    );
  }
}

class ProfileListTileShimmer extends StatelessWidget {
  const ProfileListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h), // Typical ListTile padding
      child: Row(
        children: [
          // Leading Icon Shimmer (if your ProfileListTile has an icon)
          ShimmerWidget(
            child: ShimmerContainer(width: 24.w, height: 24.h, borderRadius: 4),
          ),
          SizedBox(width: 16.w),
          // Title and Subtitle Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Shimmer - varying widths for different menu items
                ShimmerWidget(
                  child: ShimmerContainer(
                    width: _getTitleWidth(context),
                    height: 16.h, // Typical title height
                    borderRadius: 4,
                  ),
                ),
                SizedBox(height: 4.h),
                // Subtitle Shimmer
                ShimmerWidget(
                  child: ShimmerContainer(
                    width: _getSubtitleWidth(context),
                    height: 14.h, // Typical subtitle height
                    borderRadius: 4,
                  ),
                ),
              ],
            ),
          ),
          // Trailing Arrow Icon Shimmer
          ShimmerWidget(
            child: ShimmerContainer(width: 16.w, height: 16.h, borderRadius: 3),
          ),
        ],
      ),
    );
  }

  // Vary title widths for realistic appearance
  double _getTitleWidth(BuildContext context) {
    final widths = [
      100.w,
      85.w,
      110.w,
      95.w,
      75.w,
      65.w,
    ]; // Different menu item lengths
    return widths[DateTime.now().millisecond % widths.length];
  }

  // Vary subtitle widths for realistic appearance
  double _getSubtitleWidth(BuildContext context) {
    final widths = [
      140.w,
      120.w,
      160.w,
      130.w,
      150.w,
      110.w,
    ]; // Different subtitle lengths
    return widths[DateTime.now().microsecond % widths.length];
  }
}
