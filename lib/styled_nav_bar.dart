import 'features/favorite/presentation/views/favorite_view.dart';
import 'features/profile/presentation/controller/profile_provider.dart';
import 'features/profile/presentation/views/profile_view.dart';
import 'features/shop/presentation/views/shop_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/global/themes/light/app_colors_light.dart';
import 'core/utils/app_styles.dart';
import 'features/cart/presentation/views/cart_view.dart';
import 'features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'features/shop/presentation/controller/filter_models.dart';

class StyledNavBar extends StatelessWidget {
  StyledNavBar({super.key});

  final PersistentTabController _controller = PersistentTabController();

  // Navigation item data
  static const Map<String, IconData> _navItems = <String, IconData>{
    'Home': Icons.home,
    'Shop': Icons.shopping_cart_outlined,
    'Bag': Icons.shopping_bag_outlined,
    'Favorites': Icons.favorite_border_outlined,
    'Profile': Icons.person,
  };

  // Screen builders
  List<Widget> _buildScreens() => [
    const HomeView(),
    const ShopView(),
    const CartView(),
    const FavoriteView(),
    const ProfileView(),
  ];

  // Navigation bar items
  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) =>
      _navItems.entries.map((entry) {
        return PersistentBottomNavBarItem(
          icon: Icon(entry.value),
          title: entry.key,
          activeColorPrimary: AppColorsLight.kPrimary,
          textStyle: AppStyles.font11GreyMedium(context),
          inactiveColorPrimary: Colors.grey,
        );
      }).toList();

  @override
  Widget build(BuildContext context) => Consumer(
    builder: (context, ref, child) {
      return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(context),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarStyle: NavBarStyle.style9,
        onItemSelected: (index) {
          if (index == 1) {
            ref
                .read(filterParamsProvider.notifier)
                .update((state) => state.copyWith(gender: 'women'));
          }
          if (index == 4) {
            ref.invalidate(profileProvider);
          }
        },
      );
    },
  );
}
