part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoginButtonPressed extends LoginEvent {
  const LoginButtonPressed({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => <Object>[email, password];
}
