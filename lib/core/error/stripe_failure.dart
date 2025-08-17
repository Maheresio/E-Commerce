import 'failure.dart';

class StripeFailure extends Failure {
  const StripeFailure(super.message);

  factory StripeFailure.fromCode(String code) {
    switch (code) {
      case 'Canceled':
      case 'canceled':
        return const StripeFailure(
          "Payment was canceled. You can try again when you're ready.",
        );
      case 'Failed':
      case 'failed':
        return const StripeFailure(
          'Payment failed. Please check your card details and try again.',
        );
      case 'authentication_required':
        return const StripeFailure(
          'Your card requires authentication. Please complete the verification and try again.',
        );
      case 'card_declined':
        return const StripeFailure(
          'Your card was declined. Please try a different payment method or contact your bank.',
        );
      case 'expired_card':
        return const StripeFailure(
          'Your card has expired. Please use a different card or update your payment method.',
        );
      case 'incorrect_cvc':
        return const StripeFailure(
          'The security code (CVC) you entered is incorrect. Please check and try again.',
        );
      case 'insufficient_funds':
        return const StripeFailure(
          'Your card has insufficient funds. Please try a different payment method.',
        );
      case 'invalid_cvc':
        return const StripeFailure(
          'The security code (CVC) you entered is not valid. Please check and try again.',
        );
      case 'invalid_expiry_month':
        return const StripeFailure(
          'The expiry month you entered is not valid. Please check your card details.',
        );
      case 'invalid_expiry_year':
        return const StripeFailure(
          'The expiry year you entered is not valid. Please check your card details.',
        );
      case 'invalid_number':
        return const StripeFailure(
          'The card number you entered is not valid. Please check and try again.',
        );
      case 'processing_error':
        return const StripeFailure(
          'There was an error processing your payment. Please try again in a moment.',
        );
      case 'api_connection_error':
      case 'api_error':
        return const StripeFailure(
          "We're having trouble connecting to our payment processor. Please try again.",
        );
      case 'card_not_supported':
        return const StripeFailure(
          'This type of card is not supported. Please try a different payment method.',
        );
      case 'currency_not_supported':
        return const StripeFailure(
          'This currency is not supported for your payment method.',
        );
      case 'duplicate_transaction':
        return const StripeFailure(
          'This transaction appears to be a duplicate. Please check your recent payments.',
        );
      case 'fraudulent':
        return const StripeFailure(
          'This payment was declined for security reasons. Please contact your bank or try a different card.',
        );
      case 'generic_decline':
        return const StripeFailure(
          'Your payment was declined. Please contact your bank for more information.',
        );
      case 'incorrect_zip':
        return const StripeFailure(
          "The postal code you entered doesn't match your card. Please check and try again.",
        );
      case 'invalid_account':
        return const StripeFailure(
          'The payment account is invalid. Please try a different payment method.',
        );
      case 'invalid_amount':
        return const StripeFailure(
          'The payment amount is invalid. Please try again.',
        );
      case 'live_mode_mismatch':
        return const StripeFailure(
          'Payment configuration error. Please contact support.',
        );
      case 'lock_timeout':
        return const StripeFailure(
          'Payment processing timed out. Please try again.',
        );
      case 'missing':
        return const StripeFailure(
          'Required payment information is missing. Please check your details.',
        );
      case 'not_permitted':
        return const StripeFailure(
          'This payment is not permitted. Please try a different payment method.',
        );
      case 'rate_limit':
        return const StripeFailure(
          'Too many payment attempts. Please wait a moment and try again.',
        );
      case 'setup_intent_authentication_failure':
        return const StripeFailure(
          'Payment method setup failed. Please try again with a different card.',
        );
      case 'tax_id_invalid':
        return const StripeFailure(
          'The tax ID provided is invalid. Please check and try again.',
        );
      case 'testmode_charges_only':
        return const StripeFailure(
          'Only test payments are allowed in this mode.',
        );
      case 'tls_version_unsupported':
        return const StripeFailure(
          "Your device's security settings are not supported. Please update your app or device.",
        );
      case 'token_already_used':
        return const StripeFailure(
          'This payment method has already been used. Please try again.',
        );
      case 'token_in_use':
        return const StripeFailure(
          'This payment method is currently being processed. Please wait and try again.',
        );
      case 'transfers_not_allowed':
        return const StripeFailure(
          'Transfers are not allowed for this account.',
        );
      case 'upstream_timeout':
        return const StripeFailure(
          'Payment processing timed out. Please try again.',
        );
      case 'network_error':
        return const StripeFailure(
          'Network error occurred. Please check your internet connection and try again.',
        );
      case 'payment_sheet_failed':
        return const StripeFailure(
          'Failed to load payment form. Please try again.',
        );
      case 'payment_initialization_failed':
        return const StripeFailure(
          'Failed to initialize payment. Please try again.',
        );
      case 'do_not_honor':
        return const StripeFailure(
          'Your card was declined by the bank. Please contact your bank.',
        );
      case 'incorrect_pin':
        return const StripeFailure(
          'Incorrect PIN. Please try again.',
        );
      case 'lost_card':
        return const StripeFailure(
          'This card has been reported lost. Please use a different card.',
        );
      case 'stolen_card':
        return const StripeFailure(
          'This card has been reported stolen. Please use a different card.',
        );
      case 'pickup_card':
        return const StripeFailure(
          'The card cannot be used. Please contact your bank.',
        );
      case 'issuer_not_available':
        return const StripeFailure(
          'The card issuer could not be reached. Please try again later.',
        );
      default:
        return const StripeFailure(
          'Payment failed. Please try again or contact support if the issue persists.',
        );
    }
  }

  /// Creates a StripeFailure from any exception
  factory StripeFailure.fromException(dynamic exception) {
    final String errorString = exception.toString().toLowerCase();

    // Check for common patterns in error messages
    if (errorString.contains('canceled') || errorString.contains('cancelled')) {
      return StripeFailure.fromCode('canceled');
    } else if (errorString.contains('network') ||
        errorString.contains('connection')) {
      return StripeFailure.fromCode('network_error');
    } else if (errorString.contains('authentication')) {
      return StripeFailure.fromCode('authentication_required');
    } else if (errorString.contains('declined')) {
      return StripeFailure.fromCode('card_declined');
    } else if (errorString.contains('insufficient')) {
      return StripeFailure.fromCode('insufficient_funds');
    } else if (errorString.contains('expired')) {
      return StripeFailure.fromCode('expired_card');
    } else if (errorString.contains('invalid')) {
      return StripeFailure.fromCode('invalid_number');
    }

    // Default case
    return StripeFailure(exception.toString());
  }
}