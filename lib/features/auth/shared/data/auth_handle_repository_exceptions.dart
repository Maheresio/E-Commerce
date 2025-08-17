import 'dart:async';
import 'dart:io' show SocketException;

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/firebase_failure.dart';
import '../../../../core/error/firestore_failure.dart';
import 'service/auth_cancel_exception.dart';

Future<Either<Failure, T>> handleAuthRepositoryExceptions<T>(
  Future<T> Function() operation,
) async {
  try {
    final result = await operation();
    return Right(result);
  } on AuthCanceledException {
    return const Left(Failure('Sign-in canceled by user'));
  } on GoogleSignInException catch (e) {
    final codeLower = e.code.toString().toLowerCase();
    if (codeLower.contains('canceled')) {
      return const Left(Failure('Sign-in canceled by user'));
    }
    return Left(FirebaseFailure('Google Sign-In error: ${e.code}'));
  } on FirebaseAuthException catch (e) {
    return Left(FirebaseFailure.fromCode(e.code));
  } on FirebaseException catch (e) {
    return Left(FirestoreFailure.fromCode(e.code));
  } on PlatformException catch (e) {
    // For older flows
    final msg = (e.message ?? '').toLowerCase();
    final code = e.code.toLowerCase();

    if (code.contains('sign_in_canceled') ||
        code == 'canceled' ||
        msg.contains('canceled')) {
      return const Left(Failure('Sign-in canceled by user'));
    }
    if (code.contains('google') || msg.contains('sign_in')) {
      return Left(
        FirebaseFailure('Google Sign-In error: ${e.message ?? e.code}'),
      );
    }
    if (code.contains('facebook') || msg.contains('facebook')) {
      return Left(
        FirebaseFailure('Facebook Auth error: ${e.message ?? e.code}'),
      );
    }
    return Left(FirebaseFailure('Platform error: ${e.message ?? e.code}'));
  } on SocketException catch (e) {
    return Left(Failure('Network error: ${e.message}'));
  } on TimeoutException catch (e) {
    return Left(FirebaseFailure('Authentication timed out: ${e.message}'));
  } on FormatException {
    return const Left(Failure('Data format error during authentication'));
  } on ArgumentError catch (e) {
    return Left(Failure('Invalid argument: ${e.message}'));
  } on TypeError catch (e) {
    return Left(Failure('Type error: $e'));
  } catch (e) {
    final err = e.toString().toLowerCase();
    if (err.contains('firebase') || err.contains('auth')) {
      return Left(FirebaseFailure('Unexpected Firebase auth error: $e'));
    }
    if (err.contains('firestore') || err.contains('database')) {
      return Left(FirestoreFailure('Unexpected Firestore error: $e'));
    }
    if (err.contains('google') || err.contains('sign_in')) {
      return Left(FirebaseFailure('Unexpected Google Sign-In error: $e'));
    }
    if (err.contains('facebook')) {
      return Left(FirebaseFailure('Unexpected Facebook Auth error: $e'));
    }
    return Left(Failure('Unexpected error during authentication: $e'));
  }
}
