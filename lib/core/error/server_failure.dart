import 'dart:io';
import 'package:dio/dio.dart';

import 'failure.dart';

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure(
          'Connection to the server timed out. Please check your internet connection and try again.',
        );
      case DioExceptionType.sendTimeout:
        return const ServerFailure(
          'Sending data to the server took too long. Please try again later.',
        );
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(
          'Receiving data from the server took too long. Please try again later.',
        );
      case DioExceptionType.badCertificate:
        return const ServerFailure(
          "There was a problem with the server's security certificate. Please contact support.",
        );
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
      case DioExceptionType.cancel:
        return const ServerFailure('The request was canceled.');
      case DioExceptionType.connectionError:
        return const ServerFailure(
          'There was a connection error. Please check your internet connection.',
        );
      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          return const ServerFailure(
            'No internet connection. Please connect to the internet and try again.',
          );
        } else {
          return ServerFailure(
            'An unexpected error occurred: ${dioError.message}',
          );
        }
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    var message = 'Unexpected error occurred.';

    if (statusCode == null) {
      message = 'Received invalid response from the server.';
    }
    // ✅ Handle Stripe API error responses
    else if (response is Map && response.containsKey('error')) {
      final  error = response['error'];
      if (error is Map) {
        // Stripe API error format
        final stripeMessage = error['message'] ?? 'Stripe error occurred';
        final stripeType = error['type'];

        if (stripeType != null) {
          switch (stripeType) {
            case 'card_error':
              message = 'Card error: $stripeMessage';
              break;
            case 'invalid_request_error':
              message = 'Invalid request: $stripeMessage';
              break;
            case 'api_error':
              message = 'Payment service error. Please try again.';
              break;
            case 'authentication_error':
              message = 'Authentication failed. Please try again.';
              break;
            case 'rate_limit_error':
              message = 'Too many requests. Please wait and try again.';
              break;
            default:
              message = stripeMessage;
          }
        } else {
          message = stripeMessage;
        }
      } else if (error is String) {
        // Simple error string format (Next.js API)
        message = error;
      }
    }
    // ✅ Handle Clarifai-style error structure
    else if (response is Map && response.containsKey('status')) {
      final status = response['status'];
      final description = status['description'] ?? 'Unknown error';
      final details = status['details'];
      message = details != null ? '$description: $details' : description;
    }
    // ✅ Handle traditional error response like { error: { message: ... } }
    else if (statusCode >= 400 && statusCode < 500) {
      if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
        if (response is Map &&
            response.containsKey('error') &&
            response['error'] is Map &&
            response['error'].containsKey('message')) {
          message = response['error']['message'];
        } else {
          switch (statusCode) {
            case 400:
              message = 'Bad request. Please check your input.';
              break;
            case 401:
              message = 'Unauthorized. Please log in again.';
              break;
            case 403:
              message =
                  'Forbidden. You do not have permission to access this resource.';
              break;
            default:
              message = 'Client error: $statusCode';
          }
        }
      } else if (statusCode == 404) {
        message = 'The requested resource was not found.';
      } else {
        message = 'Client error: $statusCode';
      }
    }
    // ✅ Server errors
    else if (statusCode >= 500 && statusCode < 600) {
      message = 'Server error: $statusCode. Please try again later.';
    } else {
      message = 'Unexpected error: $statusCode';
    }

    return ServerFailure(message);
  }
}
