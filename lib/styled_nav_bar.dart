import 'package:e_commerce/core/global/themes/light/app_colors_light.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/cart/presentation/views/cart_view.dart';
import 'package:e_commerce/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class StyledNavBar extends StatelessWidget {
  StyledNavBar({super.key});

  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  // Navigation item data
  static const Map<String, IconData> _navItems = {
    'Home': Icons.home,
    'Shop': Icons.shopping_cart_outlined,
    'Bag': Icons.shopping_bag_outlined,
    'Favorites': Icons.favorite_border_outlined,
    'Profile': Icons.person,
  };

  // Screen builders
  List<Widget> _buildScreens() {
    return [
      const HomeView(),
      const Center(child: Text("Cart Screen")),
      const CartView(),
      const Center(child: Text("Favorites Screen")),
      const Center(child: Text("Profile Screen")),
    ];
  }

  // Navigation bar items
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return _navItems.entries.map((entry) {
      return PersistentBottomNavBarItem(
        icon: Icon(entry.value),
        title: entry.key,
        activeColorPrimary: AppColorsLight.kPrimary,
        textStyle: AppStyles.font11GreyMedium,
        inactiveColorPrimary: Colors.grey,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarStyle: NavBarStyle.style9,
    );
  }
}
