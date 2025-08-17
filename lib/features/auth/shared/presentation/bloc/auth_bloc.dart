import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_in_with_facebook_usecase.dart';
import '../../domain/entity/user_entity.dart';
import '../../../../../core/usecase/usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.signInWithGoogleUseCase,
    required this.signInWithFacebookUseCase,
  }) : super(const AuthInitial()) {
    on<GoogleSignInRequested>((event, emit) async {
      emit(const AuthLoading());
      final result = await signInWithGoogleUseCase.call(const NoParams());
      result.fold((failure) => emit(AuthFailure(failure.message)), (user) {
        if (user != null) {
          emit(AuthSuccess(user));
        } else {
          emit(const AuthFailure('Google sign-in was cancelled'));
        }
      });
    });

    on<FacebookSignInRequested>((event, emit) async {
      emit(const AuthLoading());
      final result = await signInWithFacebookUseCase.call(const NoParams());
      result.fold((failure) => emit(AuthFailure(failure.message)), (user) {
        if (user != null) {
          emit(AuthSuccess(user));
        } else {
          emit(const AuthFailure('Facebook sign-in was cancelled'));
        }
      });
    });
  }

  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithFacebookUseCase signInWithFacebookUseCase;
}
