import 'package:e_commerce/core/routing/refresh_stream.dart';
import 'package:e_commerce/features/checkout/presentation/views/payment_methods_view.dart';
import 'package:e_commerce/features/search/presentation/views/crop_image_view.dart';
import 'package:e_commerce/features/search/presentation/widgets/search_result_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login/presentation/bloc/login_bloc.dart';
import '../../features/auth/login/presentation/views/login_view.dart';
import '../../features/auth/register/presentation/bloc/register_bloc.dart';
import '../../features/auth/register/presentation/views/register_view.dart';
import '../../features/cart/presentation/views/cart_view.dart';
import '../../features/checkout/presentation/views/adding_shipping_address_view.dart';
import '../../features/checkout/presentation/views/checkout_view.dart';
import '../../features/checkout/presentation/views/shipping_address_view.dart';
import '../../features/home/domain/entities/product_entity.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/home/presentation/views/product_details_view.dart';
import '../../features/search/presentation/views/search_view.dart';
import '../../styled_nav_bar.dart';
import '../services/service_locator.dart';

abstract class AppRouter {
  static const kRegister = '/register';
  static const kLogin = '/kLogin';
  static const kHome = '/home';
  static const kLanding = '/landing';
  static const kNavBar = '/navBar';
  static const kProductDetails = '/productDetails';
  static const kCart = '/cart';
  static const kCheckout = '/checkout';
  static const kShippingAddress = '/shippingAddress';
  static const kAddShippingAddress = '/addShippingAddress';
  static const kPaymentMethods = '/paymentMethods';
  static const kSearchView = '/searchView';
  static const kCropImageView = '/cropImageView';
  static const kSearchResultView = '/searchResultView';

  static final _auth = sl<FirebaseAuth>();

  static final GoRouter router = GoRouter(
    initialLocation: _auth.currentUser != null ? kNavBar : kLogin,
    refreshListenable: GoRouterRefreshStream(_auth.authStateChanges()),

    redirect: (context, state) {
      final user = _auth.currentUser;
      final isLoggedIn = user != null;
      final isOnAuthPage =
          state.uri.path == kLogin || state.uri.path == kRegister;

      // If user is logged in and on auth page, redirect to navbar
      if (isLoggedIn && isOnAuthPage) {
        return kNavBar;
      }

      // If user is not logged in and not on auth page, redirect to login
      if (!isLoggedIn && !isOnAuthPage) {
        return kLogin;
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: kLogin,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<LoginBloc>(),
            child: LoginView(),
          );
        },
      ),
      GoRoute(
        path: kRegister,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<RegisterBloc>(),
            child: RegisterView(),
          );
        },
      ),
      GoRoute(path: kHome, builder: (context, state) => HomeView()),
      GoRoute(path: kNavBar, builder: (context, state) => StyledNavBar()),
      GoRoute(path: kCart, builder: (context, state) => CartView()),
      GoRoute(path: kCheckout, builder: (context, state) => CheckoutView()),
      GoRoute(
        path: kSearchResultView,
        builder: (context, state) => SearchResultView(),
      ),

      GoRoute(
        path: kSearchView,
        builder: (context, state) {
          return SearchView();
        },
      ),

      GoRoute(
        path: kCropImageView,
        builder:
            (context, state) => CropImageView(imagePath: state.extra as String),
      ),
      GoRoute(
        path: kPaymentMethods,
        builder: (context, state) => PaymentMethodsView(),
      ),
      GoRoute(
        path: kAddShippingAddress,
        builder: (context, state) => AddingShippingAddressView(),
      ),
      GoRoute(
        path: kShippingAddress,
        builder: (context, state) => ShippingAddressView(),
      ),
      GoRoute(
        path: kProductDetails,
        builder:
            (context, state) =>
                ProductDetailsView(state.extra as ProductEntity),
      ),
    ],
  );
}
