abstract class FirestoreConstants {
  // Products
  static String get products => 'products/';
  static String product(String id) => 'products/$id';

  // Users
  static String get users => 'users/';
  static String user(String uid) => 'users/$uid';

  // Favorites
  static String get favorites => 'favorites/';
  static String userAllFavorites(String userId) => 'users/$userId/favorites';
  static String userFavorite(String userId, String productId) =>
      'users/$userId/favorites/$productId';

  // Cart
  static String get cart => 'cart/';
  static String userCart(String userId) => 'users/$userId/cart';
  static String userCartItem(String userId, String itemId) =>
      'users/$userId/cart/$itemId';

  // Addresses
  static String get shippingAddresses => 'shipping_addresses/';
  static String userAllAddresses(String userId) =>
      'users/$userId/shipping_addresses';
  static String userAddress(String userId, String addressId) =>
      'users/$userId/shipping_addresses/$addressId';

  // Payment Cards
  static String get visaCards => 'visa_cards/';
  static String userVisaCards(String userId) => 'users/$userId/visa_cards';
  static String userVisaCard(String userId, String cardId) =>
      'users/$userId/visa_cards/$cardId';

  // Orders (updated for checkout feature)
  static String get orders => 'orders';
  static String order(String orderId) => 'orders/$orderId';
  static String userOrders(String userId) => 'users/$userId/orders';
  static String userOrder(String userId, String orderId) =>
      'users/$userId/orders/$orderId';

  // Delivery Methods (common collection)
  static String get deliveryMethods => 'delivery_methods/';

  static String deliveryMethod(String methodId) => 'delivery_methods/$methodId';

  // Reviews
  static String get reviews => 'reviews';
  static String review(String reviewId) => 'reviews/$reviewId';
}
