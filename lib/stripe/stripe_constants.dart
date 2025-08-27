import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class StripeConstants {
  static final String publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static final String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';

  static String get baseUrl => 'https://api.stripe.com';
  static String get paymentIntentEndpoint => '$baseUrl/v1/payment_intents';

  static Map<String, String> get headers => <String, String>{
    'Authorization': 'Bearer ${StripeConstants.secretKey}',
    'Content-Type': 'application/x-www-form-urlencoded',
  };
}
