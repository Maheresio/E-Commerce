import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/login_with_email_and_password_use_case.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.loginWithEmailAndPasswordUseCase) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      final result = await loginWithEmailAndPasswordUseCase.execute(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) => emit(LoginFailure(failure.message)),
        (user) => emit(LoginSuccess()),
      );
    });
  }

  final LoginWithEmailAndPasswordUseCase loginWithEmailAndPasswordUseCase;
}
