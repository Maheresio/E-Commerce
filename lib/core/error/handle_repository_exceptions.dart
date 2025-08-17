import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'failure.dart';
import 'firebase_failure.dart';
import 'firestore_failure.dart';
import 'server_failure.dart';
import 'socket_failure.dart';
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
  } on FirebaseAuthException catch (e) {
    return Left(FirebaseFailure.fromCode(e.code));
  }
   on FirebaseException catch (e) {
    return Left(FirestoreFailure.fromCode(e.code));
  } on DioException catch (e) {
    return Left(ServerFailure.fromDioError(e));
  } on SocketException catch (e) {
    return Left(SocketFailure.fromSocketException(e));
  } on HttpException catch (e) {
    return Left(ServerFailure('HTTP error: ${e.message}'));
  } on FormatException {
    return const Left(Failure('Data format error'));
  }on MissingPluginException catch (e) {
    return Left(FirebaseFailure('Plugin configuration error: ${e.message}. Please check platform setup for Facebook auth.'));
  } 
  catch (e) {
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