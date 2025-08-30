import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/login/data/datasources/login_data_source.dart';
import '../../features/auth/login/data/repositories/login_repository_impl.dart';
import '../../features/auth/login/domain/repositories/login_repository.dart';
import '../../features/auth/login/domain/usecases/login_with_email_and_password_use_case.dart';
import '../../features/auth/login/presentation/bloc/login_bloc.dart';
import '../../features/auth/register/data/datasources/register_data_source.dart';
import '../../features/auth/register/data/repositories/register_repository_impl.dart';
import '../../features/auth/register/domain/repositories/register_repository.dart';
import '../../features/auth/register/domain/usecases/register_with_email_and_password_usecase.dart';
import '../../features/auth/register/presentation/bloc/register_bloc.dart';
import '../../features/auth/shared/data/data_source/auth_data_source.dart';
import '../../features/auth/shared/data/repositories/auth_repository_impl.dart';
import '../../features/auth/shared/domain/repositories/auth_repository.dart';
import '../../features/auth/shared/domain/usecases/sign_in_with_facebook_usecase.dart';
import '../../features/auth/shared/domain/usecases/sign_in_with_google_usecase.dart';
import '../../features/auth/shared/presentation/bloc/auth_bloc.dart';
import '../network/dio_client.dart';
import 'current_user_service.dart';
import 'firestore_sevice.dart';
import 'supabase_storage_service.dart';

final GetIt sl = GetIt.instance;

void serviceLocator() {
  // Core services
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirestoreServices>(() => FirestoreServices.instance);

  sl.registerLazySingleton<CurrentUserService>(
    () => CurrentUserService(
      firebaseAuth: sl<FirebaseAuth>(),
      firestoreServices: sl<FirestoreServices>(),
    ),
  );

  sl.registerLazySingleton<DioClient>(DioClient.new);
  sl.registerLazySingleton<SupabaseStorageService>(SupabaseStorageService.new);

  // Auth Feature
  // -- Register
  sl.registerLazySingleton<RegisterDataSource>(
    () => RegisterDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestoreServices: sl<FirestoreServices>(),
    ),
  );
  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(sl<RegisterDataSource>()),
  );
  sl.registerLazySingleton<RegisterWithEmailAndPasswordUsecase>(
    () => RegisterWithEmailAndPasswordUsecase(sl<RegisterRepository>()),
  );
  sl.registerFactory<RegisterBloc>(
    () => RegisterBloc(sl<RegisterWithEmailAndPasswordUsecase>()),
  );

  // -- Login
  sl.registerLazySingleton<LoginDataSource>(
    () => LoginDataSourceImpl(firebaseAuth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(sl<LoginDataSource>()),
  );
  sl.registerLazySingleton<LoginWithEmailAndPasswordUseCase>(
    () => LoginWithEmailAndPasswordUseCase(sl<LoginRepository>()),
  );

  // -- Auth (Social Authentication)
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestoreServices: sl<FirestoreServices>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthDataSource>()),
  );
  sl.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignInWithFacebookUseCase>(
    () => SignInWithFacebookUseCase(sl<AuthRepository>()),
  );

  // -- Blocs
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(sl<LoginWithEmailAndPasswordUseCase>()),
  );

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      signInWithGoogleUseCase: sl<SignInWithGoogleUseCase>(),
      signInWithFacebookUseCase: sl<SignInWithFacebookUseCase>(),
    ),
  );
}
