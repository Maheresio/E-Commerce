import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

abstract class CheckoutRemoteDataSource {
  Future<void> initializePaymentSheet({
    required String clientSecret,
    required String customerId,
    String? ephemeralKey,
    dynamic defaultCard,
    dynamic defaultAddress,
  });

  Future<void> presentPaymentSheet();
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  @override
  Future<void> initializePaymentSheet({
    required String clientSecret,
    required String customerId,
    String? ephemeralKey,
    dynamic defaultCard,
    dynamic defaultAddress,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'My Shop',
        customerId: customerId,
        customerEphemeralKeySecret: ephemeralKey,
        style: ThemeMode.system,
        billingDetails:
            defaultAddress != null
                ? BillingDetails(
                  name: defaultAddress.name,
                  email: FirebaseAuth.instance.currentUser?.email,
                  address: Address(
                    city: defaultAddress.city,
                    country: defaultAddress.country,
                    line1: defaultAddress.street,
                    line2: '',
                    postalCode: defaultAddress.zipCode,
                    state: defaultAddress.state,
                  ),
                )
                : BillingDetails(
                  email: FirebaseAuth.instance.currentUser?.email,
                ),
        returnURL: 'your-app://return',
        primaryButtonLabel:
            defaultCard != null
                ? 'Pay with •••• ${defaultCard.last4}'
                : 'Complete Payment',
        appearance: const PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(),
        ),
      ),
    );
  }

  @override
  Future<void> presentPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }
}
