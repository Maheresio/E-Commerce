// Core Flutter imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Auth feature imports
import '../../features/auth/login/presentation/bloc/login_bloc.dart';
import '../../features/auth/login/presentation/views/login_view.dart';
import '../../features/auth/register/presentation/bloc/register_bloc.dart';
import '../../features/auth/register/presentation/views/register_view.dart';
// Cart & Checkout feature imports
import '../../features/cart/presentation/views/cart_view.dart';
// Entity imports
import '../../features/checkout/domain/entities/order_entity.dart';
import '../../features/checkout/domain/entities/shipping_address_entity.dart';
import '../../features/checkout/presentation/views/adding_shipping_address_view.dart';
import '../../features/checkout/presentation/views/checkout_view.dart';
import '../../features/checkout/presentation/views/payment_methods_view.dart';
import '../../features/checkout/presentation/views/shipping_address_view.dart';
import '../../features/checkout/presentation/views/success_view.dart';
import '../../features/common/presentation/views/filters_view.dart';
// Common feature imports
import '../../features/common/presentation/views/see_all_view.dart';
// Other feature imports
import '../../features/favorite/presentation/views/favorite_view.dart';
import '../../features/home/domain/entities/product_entity.dart';
// Home feature imports
import '../../features/home/presentation/views/home_view.dart';
import '../../features/home/presentation/views/product_details_view.dart';
import '../../features/profile/presentation/views/my_orders_view.dart';
import '../../features/profile/presentation/views/order_details_view.dart';
// Profile feature imports
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/profile/presentation/views/settings_view.dart';
import '../../features/review/presentation/views/review_view.dart';
import '../../features/search/presentation/views/crop_image_view.dart';
import '../../features/search/presentation/views/search_result_view.dart';
// Search feature imports
import '../../features/search/presentation/views/search_view.dart';
import '../../features/shop/presentation/views/category_view.dart';
// Shop feature imports
import '../../features/shop/presentation/views/shop_view.dart';
import '../../styled_nav_bar.dart';
// Core app imports
import '../services/service_locator.dart';
import '../widgets/auth_wrapper.dart' show AuthWrapper;
import 'animated_router.dart';
import 'app_route_constants.dart';
import 'refresh_stream.dart';

/// App Router Configuration
///
/// Centralized routing configuration for the e-commerce application.
/// Uses GoRouter for declarative routing with authentication state management.
/// Includes custom page transitions for smooth animated navigation.
abstract class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  // Route constants for backward compatibility
  static const String kLogin = AppRoutes.login;
  static const String kRegister = AppRoutes.register;
  static const String kHome = AppRoutes.home;
  static const String kNavBar = AppRoutes.navBar;
  static const String kCart = AppRoutes.cart;
  static const String kShopView = AppRoutes.shop;
  static const String kCategoryView = AppRoutes.category;
  static const String kProductDetails = AppRoutes.productDetails;
  static const String kCheckout = AppRoutes.checkout;
  static const String kShippingAddress = AppRoutes.shippingAddress;
  static const String kAddShippingAddress = AppRoutes.addShippingAddress;
  static const String kPaymentMethods = AppRoutes.paymentMethods;
  static const String kSuccessView = AppRoutes.success;
  static const String kSearchView = AppRoutes.search;
  static const String kSearchResultView = AppRoutes.searchResult;
  static const String kCropImageView = AppRoutes.cropImage;
  static const String kSeeAllView = AppRoutes.seeAll;
  static const String kFilterView = AppRoutes.filters;
  static const String kReviewView = AppRoutes.review;
  static const String kFavoriteView = AppRoutes.favorite;
  static const String kProfileView = AppRoutes.profile;
  static const String kMyOrdersView = AppRoutes.myOrders;
  static const String kOrderDetailsView = AppRoutes.orderDetails;
  static const String kSettingsView = AppRoutes.settings;

  // Firebase Auth instance for authentication state
  static final FirebaseAuth _auth = sl<FirebaseAuth>();

  /// Main router configuration with custom page transitions
  static final GoRouter router = GoRouter(
    initialLocation:
        _auth.currentUser != null ? AppRoutes.navBar : AppRoutes.login,
    refreshListenable: GoRouterRefreshStream(_auth.authStateChanges()),
    redirect: _handleRedirect,

    routes: [
      // Auth Routes
      ..._authRoutes,

      // Main Navigation Routes
      ..._mainRoutes,

      // Shopping Routes
      ..._shoppingRoutes,

      // Checkout Routes
      ..._checkoutRoutes,

      // Search & Discovery Routes
      ..._searchRoutes,

      // Profile & Account Routes
      ..._profileRoutes,
    ],
  );

  /// Handles authentication-based redirects
  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final User? user = _auth.currentUser;
    final bool isLoggedIn = user != null;
    final bool isOnAuthPage =
        state.uri.path == AppRoutes.login ||
        state.uri.path == AppRoutes.register;

    // If user is logged in and on auth page, redirect to navbar
    if (isLoggedIn && isOnAuthPage) {
      return AppRoutes.navBar;
    }

    // If user is not logged in and not on auth page, redirect to login
    if (!isLoggedIn && !isOnAuthPage) {
      return AppRoutes.login;
    }

    return null; // No redirect needed
  }

  /// Authentication routes with fade scale transitions
  static List<RouteBase> get _authRoutes => [
    AnimatedRoute.fadeScale(
      path: AppRoutes.login,
      builder:
          (context, state) => AuthWrapper(
            child: BlocProvider(
              create: (context) => sl<LoginBloc>(),
              child: const LoginView(),
            ),
          ),
    ),
    AnimatedRoute.fadeScale(
      path: AppRoutes.register,
      builder:
          (context, state) => AuthWrapper(
            child: BlocProvider(
              create: (context) => sl<RegisterBloc>(),
              child: const RegisterView(),
            ),
          ),
    ),
  ];

  /// Main navigation routes with slide transitions
  static List<RouteBase> get _mainRoutes => [
    AnimatedRoute.slideRight(
      path: AppRoutes.home,
      builder: (context, state) => const HomeView(),
    ),
    AnimatedRoute.fadeScale(
      path: AppRoutes.navBar,
      builder: (context, state) => StyledNavBar(),
    ),
  ];

  /// Shopping related routes with hero transitions
  static List<RouteBase> get _shoppingRoutes => [
    AnimatedRoute.slideRight(
      path: AppRoutes.cart,
      builder: (context, state) => const CartView(),
    ),
    AnimatedRoute.slideRight(
      path: AppRoutes.shop,
      builder: (context, state) => const ShopView(),
    ),
    AnimatedRoute.slideRight(
      path: AppRoutes.category,
      builder:
          (context, state) => CategoryView(
            genderList: (state.extra! as (Map<String, dynamic>, int)).$1,
            index: (state.extra! as (Map<String, dynamic>, int)).$2,
          ),
    ),
    AnimatedRoute.fadeScale(
      path: AppRoutes.productDetails,
      builder:
          (context, state) => ProductDetailsView(state.extra! as ProductEntity),
    ),
  ];

  /// Checkout flow routes with smooth checkout transitions
  static List<RouteBase> get _checkoutRoutes => [
    AnimatedRoute.checkout(
      path: AppRoutes.checkout,
      builder: (context, state) => CheckoutView(state.extra! as double),
    ),
    AnimatedRoute.checkout(
      path: AppRoutes.shippingAddress,
      builder: (context, state) => const ShippingAddressView(),
    ),
    AnimatedRoute.fadeScale(
      path: AppRoutes.addShippingAddress,
      builder:
          (context, state) =>
              state.extra != null
                  ? AddingShippingAddressView(
                    address: state.extra! as ShippingAddressEntity,
                  )
                  : const AddingShippingAddressView(),
    ),
    AnimatedRoute.checkout(
      path: AppRoutes.paymentMethods,
      builder: (context, state) => const PaymentMethodsView(),
    ),
    AnimatedRoute.fadeScale(
      path: AppRoutes.success,
      builder: (context, state) => const SuccessView(),
    ),
  ];

  /// Search and discovery routes with search transitions
  static List<RouteBase> get _searchRoutes => [
    AnimatedRoute.search(
      path: AppRoutes.search,
      builder: (context, state) => const SearchView(),
    ),
    AnimatedRoute.search(
      path: AppRoutes.searchResult,
      builder: (context, state) => const SearchResultView(),
    ),
    AnimatedRoute.slideUp(
      path: AppRoutes.cropImage,
      builder: (context, state) {
        if (state.extra == null || state.extra is! String) {
          return const Scaffold(
            body: Center(child: Text('Invalid image path. Please try again.')),
          );
        }
        return CropImageView(imagePath: state.extra as String);
      },
    ),
    AnimatedRoute.slideRight(
      path: AppRoutes.seeAll,
      builder:
          (context, state) => Consumer(
            builder: (context, ref, _) {
              final Map<String, dynamic> result =
                  state.extra! as Map<String, dynamic>;
              final type = result['type'];

              switch (type) {
                case 'filtered':
                  return SeeAllView.filtered(ref);
                case 'all':
                  return SeeAllView.all(ref);
                case 'sale':
                  return SeeAllView.sale(ref);
                case 'byGender':
                  return SeeAllView.byGender(ref, result['gender']);
                case 'byGenderAndSub':
                  return SeeAllView.byGenderAndSub(
                    ref,
                    result['gender'],
                    result['subCategory'],
                  );
                case 'newestByGender':
                  return SeeAllView.newestByGender(ref, result['gender']);
                default:
                  return const Scaffold(
                    body: Center(child: Text('Invalid type')),
                  );
              }
            },
          ),
    ),
    AnimatedRoute.slideUp(
      path: AppRoutes.filters,
      builder: (context, state) => const FiltersView(),
    ),
  ];

  /// Profile and account routes with profile transitions
  static List<RouteBase> get _profileRoutes => [
    AnimatedRoute.profile(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileView(),
    ),
    AnimatedRoute.slideRight(
      path: AppRoutes.favorite,
      builder: (context, state) => const FavoriteView(),
    ),
    AnimatedRoute.profile(
      path: AppRoutes.myOrders,
      builder: (context, state) => const MyOrdersView(),
    ),
    AnimatedRoute.slideRight(
      path: AppRoutes.orderDetails,
      builder:
          (context, state) => OrderDetailsView(state.extra! as OrderEntity),
    ),
    AnimatedRoute.profile(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsView(),
    ),
    AnimatedRoute.slideUp(
      path: AppRoutes.review,
      builder: (context, state) => ReviewView(state.extra! as ProductEntity),
    ),
  ];
}
