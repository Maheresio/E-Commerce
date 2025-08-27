import 'package:dartz/dartz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/error/handle_repository_exceptions.dart';
import '../../../../../core/error/stripe_failure.dart';

/// Specialized exception handler for checkout operations with enhanced Stripe error handling
Future<Either<Failure, T>> handleCheckoutExceptions<T>(
  Future<T> Function() operation,
) async {
  try {
    final result = await operation();
    return Right(result);
  } on StripeException catch (e) {
    // Handle specific Stripe exceptions with detailed error codes
    var errorCode = 'failed'; // default

    final String errorMessage = e.error.message?.toLowerCase() ?? '';

    if (errorMessage.contains('canceled')) {
      errorCode = 'canceled';
    } else if (errorMessage.contains('authentication')) {
      errorCode = 'authentication_required';
    } else if (errorMessage.contains('declined')) {
      errorCode = 'card_declined';
    } else if (errorMessage.contains('insufficient')) {
      errorCode = 'insufficient_funds';
    } else if (errorMessage.contains('expired')) {
      errorCode = 'expired_card';
    } else if (errorMessage.contains('invalid')) {
      errorCode = 'invalid_number';
    } else if (errorMessage.contains('network')) {
      errorCode = 'network_error';
    }

    return Left(StripeFailure.fromCode(errorCode));
  } on StripeConfigException catch (_) {
    return Left(StripeFailure.fromCode('payment_initialization_failed'));
  } catch (e) {
    // Check if it's a payment sheet related error
    final String errorString = e.toString().toLowerCase();
    if (errorString.contains('payment') && errorString.contains('sheet')) {
      return Left(StripeFailure.fromCode('payment_sheet_failed'));
    } else if (errorString.contains('stripe')) {
      return Left(StripeFailure.fromException(e));
    }

    // Fall back to general repository exception handling
    return handleRepositoryExceptions(() async => throw e);
  }
}
