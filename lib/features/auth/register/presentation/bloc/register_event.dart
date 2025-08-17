part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => <Object>[];
}

class RegisterButtonPressed extends RegisterEvent {
  const RegisterButtonPressed({
    required this.email,
    required this.name,
    required this.password,
  });
  final String email;
  final String name;
  final String password;
  @override
  List<Object> get props => <Object>[email, name, password];
}
