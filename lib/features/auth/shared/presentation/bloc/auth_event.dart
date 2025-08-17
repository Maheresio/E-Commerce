part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

class FacebookSignInRequested extends AuthEvent {
  const FacebookSignInRequested();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
