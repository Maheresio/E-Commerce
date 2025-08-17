/// Route constants for the application
///
/// Contains all the route paths used throughout the application.
/// These constants ensure consistency and make route management easier.
abstract class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Auth routes
  static const String login = '/login';
  static const String register = '/register';

  // Main navigation
  static const String home = '/home';
  static const String landing = '/landing';
  static const String navBar = '/navBar';

  // Shopping
  static const String cart = '/cart';
  static const String shop = '/shopView';
  static const String category = '/categoryView';
  static const String productDetails = '/productDetails';

  // Checkout flow
  static const String checkout = '/checkout';
  static const String shippingAddress = '/shippingAddress';
  static const String addShippingAddress = '/addShippingAddress';
  static const String paymentMethods = '/paymentMethods';
  static const String success = '/successView';

  // Search & Discovery
  static const String search = '/searchView';
  static const String searchResult = '/searchResultView';
  static const String cropImage = '/cropImageView';
  static const String seeAll = '/seeAllView';
  static const String filters = '/filterView';

  // Social & Reviews
  static const String review = '/reviewView';
  static const String favorite = '/favoriteView';

  // Profile & Account
  static const String profile = '/profileView';
  static const String myOrders = '/myOrdersView';
  static const String orderDetails = '/orderDetailsView';
  static const String settings = '/settingsView';
}
