// Core Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Core app imports
import '../services/service_locator.dart';
import '../widgets/auth_wrapper.dart' show AuthWrapper;
import '../../styled_nav_bar.dart';
import 'app_route_constants.dart';
import 'refresh_stream.dart';

// Entity imports
import '../../features/checkout/domain/entities/order_entity.dart';
import '../../features/checkout/domain/entities/shipping_address_entity.dart';
import '../../features/home/domain/entities/product_entity.dart';

// Auth feature imports
import '../../features/auth/login/presentation/bloc/login_bloc.dart';
import '../../features/auth/login/presentation/views/login_view.dart';
import '../../features/auth/register/presentation/bloc/register_bloc.dart';
import '../../features/auth/register/presentation/views/register_view.dart';

// Home feature imports
import '../../features/home/presentation/views/home_view.dart';
import '../../features/home/presentation/views/product_details_view.dart';

// Cart & Checkout feature imports
import '../../features/cart/presentation/views/cart_view.dart';
import '../../features/checkout/presentation/views/checkout_view.dart';
import '../../features/checkout/presentation/views/shipping_address_view.dart';
import '../../features/checkout/presentation/views/adding_shipping_address_view.dart';
import '../../features/checkout/presentation/views/payment_methods_view.dart';
import '../../features/checkout/presentation/views/success_view.dart';

// Shop feature imports
import '../../features/shop/presentation/views/shop_view.dart';
import '../../features/shop/presentation/views/category_view.dart';

// Search feature imports
import '../../features/search/presentation/views/search_view.dart';
import '../../features/search/presentation/views/crop_image_view.dart';
import '../../features/search/presentation/widgets/search_result_view.dart';

// Common feature imports
import '../../features/common/presentation/views/see_all_view.dart';
import '../../features/common/presentation/views/filters_view.dart';

// Profile feature imports
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/profile/presentation/views/my_orders_view.dart';
import '../../features/profile/presentation/views/order_details_view.dart';
import '../../features/profile/presentation/views/settings_view.dart';

// Other feature imports
import '../../features/favorite/presentation/views/favorite_view.dart';
import '../../features/review/presentation/views/review_view.dart';

/// App Router Configuration
///
/// Centralized routing configuration for the e-commerce application.
/// Uses GoRouter for declarative routing with authentication state management.
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

  /// Main router configuration
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

  /// Authentication routes
  static List<RouteBase> get _authRoutes => [
    GoRoute(
      path: AppRoutes.login,
      builder:
          (context, state) => AuthWrapper(
            child: BlocProvider(
              create: (context) => sl<LoginBloc>(),
              child: const LoginView(),
            ),
          ),
    ),
    GoRoute(
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

  /// Main navigation routes
  static List<RouteBase> get _mainRoutes => [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: AppRoutes.navBar,
      builder: (context, state) => StyledNavBar(),
    ),
  ];

  /// Shopping related routes
  static List<RouteBase> get _shoppingRoutes => [
    GoRoute(
      path: AppRoutes.cart,
      builder: (context, state) => const CartView(),
    ),
    GoRoute(
      path: AppRoutes.shop,
      builder: (context, state) => const ShopView(),
    ),
    GoRoute(
      path: AppRoutes.category,
      builder: (context, state) {
        final (Map<String, dynamic>, int) result =
            state.extra! as (Map<String, dynamic>, int);
        return CategoryView(genderList: result.$1, index: result.$2);
      },
    ),
    GoRoute(
      path: AppRoutes.productDetails,
      builder: (context, state) {
        final ProductEntity product = state.extra! as ProductEntity;
        return ProductDetailsView(product);
      },
    ),
  ];

  /// Checkout flow routes
  static List<RouteBase> get _checkoutRoutes => [
    GoRoute(
      path: AppRoutes.checkout,
      builder: (context, state) {
        final double cartTotal = state.extra! as double;
        return CheckoutView(cartTotal);
      },
    ),
    GoRoute(
      path: AppRoutes.shippingAddress,
      builder: (context, state) => const ShippingAddressView(),
    ),
    GoRoute(
      path: AppRoutes.addShippingAddress,
      builder: (context, state) {
        if (state.extra != null) {
          return AddingShippingAddressView(
            address: state.extra! as ShippingAddressEntity,
          );
        }
        return const AddingShippingAddressView();
      },
    ),
    GoRoute(
      path: AppRoutes.paymentMethods,
      builder: (context, state) => const PaymentMethodsView(),
    ),
    GoRoute(
      path: AppRoutes.success,
      builder: (context, state) => const SuccessView(),
    ),
  ];

  /// Search and discovery routes
  static List<RouteBase> get _searchRoutes => [
    GoRoute(
      path: AppRoutes.search,
      builder: (context, state) => const SearchView(),
    ),
    GoRoute(
      path: AppRoutes.searchResult,
      builder: (context, state) => const SearchResultView(),
    ),
    GoRoute(
      path: AppRoutes.cropImage,
      builder: (context, state) {
        final String imagePath = state.extra! as String;
        return CropImageView(imagePath: imagePath);
      },
    ),
    GoRoute(
      path: AppRoutes.seeAll,
      builder: (context, state) {
        final Map<String, dynamic> result =
            state.extra! as Map<String, dynamic>;
        final type = result['type'];

        return Consumer(
          builder: (context, ref, _) {
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
        );
      },
    ),
    GoRoute(
      path: AppRoutes.filters,
      builder: (context, state) => const FiltersView(),
    ),
  ];

  /// Profile and account routes
  static List<RouteBase> get _profileRoutes => [
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: AppRoutes.favorite,
      builder: (context, state) => const FavoriteView(),
    ),
    GoRoute(
      path: AppRoutes.myOrders,
      builder: (context, state) => const MyOrdersView(),
    ),
    GoRoute(
      path: AppRoutes.orderDetails,
      builder: (context, state) {
        final OrderEntity order = state.extra! as OrderEntity;
        return OrderDetailsView(order);
      },
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: AppRoutes.review,
      builder: (context, state) {
        final ProductEntity product = state.extra! as ProductEntity;
        return ReviewView(product);
      },
    ),
  ];
}
