import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'server_failure.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'failure.dart';
import 'firestore_failure.dart';
import 'stripe_failure.dart';

Future<Either<Failure, T>> handleRepositoryExceptions<T>(
  Future<T> Function() operation,
) async {
  try {
    final result = await operation();
    return Right(result);
  } on StripeException catch (e) {
    return Left(StripeFailure.fromException(e));
  } on StripeConfigException catch (e) {
    return Left(StripeFailure.fromException(e));
  } on FirebaseException catch (e) {
    return Left(FirestoreFailure.fromCode(e.code));
  } on DioException catch (e) {
    return Left(ServerFailure.fromDioError(e));
  } on SocketException {
    return const Left(Failure('No internet connection'));
  } on FormatException {
    return const Left(Failure('Data format error'));
  } catch (e) {
    // Check if it's a Stripe-related error by examining the error message
    final String errorString = e.toString().toLowerCase();
    if (errorString.contains('stripe') ||
        errorString.contains('payment') ||
        errorString.contains('card') ||
        errorString.contains('declined') ||
        errorString.contains('canceled') ||
        errorString.contains('authentication')) {
      return Left(StripeFailure.fromException(e));
    }
    return Left(Failure('Unexpected error: $e'));
  }
}
