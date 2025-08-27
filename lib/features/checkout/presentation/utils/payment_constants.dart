class PaymentConstants {
  // Base URL for Stripe backend API
  static const String baseUrl = 'https://stripe-backend-api-mauve.vercel.app';

  // Payment API endpoints
  static const String _createPaymentIntentEndpoint =
      '/api/create-payment-intents';
  static const String createSetupIntentEndpoint = '/api/create-setup-intent';

  // Card management API endpoints
  static const String _detachCardEndpoint = '/api/detach-card';
  static const String _getCardsEndpoint = '/api/list-cards';
  static const String _setDefaultCardEndpoint = '/api/set-default-card';
  static const String _createEphemeralKeyEndpoint = '/api/create-ephemeral-key';

  // Customer management API endpoint
  static const String _getOrCreateCustomerEndpoint = '/api/getOrCreateCustomer';

  // Full URL getters
  static String get createPaymentIntentUrl =>
      '$baseUrl$_createPaymentIntentEndpoint';
  static String get createSetupIntentUrl =>
      '$baseUrl$createSetupIntentEndpoint';
  static String get detachCardUrl => '$baseUrl$_detachCardEndpoint';
  static String get getCardsUrl => '$baseUrl$_getCardsEndpoint';
  static String get setDefaultCardUrl => '$baseUrl$_setDefaultCardEndpoint';
  static String get getOrCreateCustomerUrl =>
      '$baseUrl$_getOrCreateCustomerEndpoint';

  static String get createEphemeralKeyUrl =>
      '$baseUrl$_createEphemeralKeyEndpoint';
}
