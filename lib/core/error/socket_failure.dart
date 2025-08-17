import 'dart:io';
import 'failure.dart';

class SocketFailure extends Failure {
  const SocketFailure(super.message);

  factory SocketFailure.fromCode(String code) {
    switch (code) {
      case 'network-request-failed':
        return const SocketFailure(
          'A network error occurred. Please check your connection.',
        );
      case 'connection-timeout':
        return const SocketFailure(
          'Connection timed out. Please check your internet connection and try again.',
        );
      case 'host-unreachable':
        return const SocketFailure(
          'Unable to reach the server. Please check your internet connection.',
        );
      case 'connection-refused':
        return const SocketFailure(
          'Server refused the connection. Please try again later.',
        );
      case 'no-address':
        return const SocketFailure(
          'Cannot resolve server address. Please check your internet connection.',
        );
      case 'network-unreachable':
        return const SocketFailure(
          'Network is unreachable. Please check your internet connection.',
        );
      default:
        return const SocketFailure('An unknown network error occurred.');
    }
  }

  factory SocketFailure.fromSocketException(SocketException exception) {
    final errorCode = exception.osError?.errorCode;
    final message = exception.message.toLowerCase();

    if (errorCode == 7 || message.contains('no address')) {
      return SocketFailure.fromCode('no-address');
    } else if (errorCode == 61 || message.contains('connection refused')) {
      return SocketFailure.fromCode('connection-refused');
    } else if (errorCode == 60 || message.contains('timeout')) {
      return SocketFailure.fromCode('connection-timeout');
    } else if (message.contains('unreachable')) {
      return SocketFailure.fromCode('host-unreachable');
    } else {
      return SocketFailure.fromCode('network-request-failed');
    }
  }
}