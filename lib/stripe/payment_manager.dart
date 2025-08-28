import '../core/network/dio_client.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'stripe_constants.dart';

abstract class PaymentManager {
  static Future<void> makePayment({
    required int amount,
    required String currency,
  }) async {
    // Implement payment logic here
    try {
      final clientSecret = await _getClientSecret(
        amount: (amount * 100).toString(),
        currency: currency,
      );
      await _initializePaymentSheet(clientSecret, 'Your Merchant Name');
      await Stripe.instance.presentPaymentSheet();
    } on Exception catch (e) {
      throw Exception('Failed to create payment intent: $e.');
    }
  }

  static Future<String> _getClientSecret({
    required String amount,
    required String currency,
  }) async {
    final response = await DioClient().post(
      url: StripeConstants.paymentIntentEndpoint,
      headers: StripeConstants.headers,
      data: <String, dynamic>{'amount': amount, 'currency': currency},
    );
    return response.data['client_secret'];
  }

  static Future<void> _initializePaymentSheet(
    String clientSecret,
    String merchantDisplayName,
  ) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: merchantDisplayName,
      ),
    );
  }
}
