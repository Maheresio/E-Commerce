import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/register_with_email_and_password_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterWithEmailAndPasswordUsecase registerWithEmailAndPasswordUsecase;

  RegisterBloc(this.registerWithEmailAndPasswordUsecase)
    : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      final result = await registerWithEmailAndPasswordUsecase.execute(
        email: event.email,
        name: event.name,
        password: event.password,
      );
      result.fold(
        (failure) {
          emit(RegisterFailure(failure.message));
        },
        (success) {
          emit(RegisterSuccess());
        },
      );
    });
  }
}
