import '../network/dio_client.dart';
import 'firestore_sevice.dart';
import 'supabase_storage_service.dart';
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
import '../../features/auth/shared/data/service/firebase_auth_service_impl.dart';
import 'firebase_auth_service.dart';

final GetIt sl = GetIt.instance;

void serviceLocator() {
  // Core services
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirestoreServices>(() => FirestoreServices.instance);

  sl.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthServiceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestoreServices: sl<FirestoreServices>(),
    ),
  );

  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<SupabaseStorageService>(
    () => SupabaseStorageService(),
  );

  // Auth Feature
  // -- Register
  sl.registerLazySingleton<RegisterDataSource>(
    () => RegisterDataSourceImpl(sl<FirebaseAuthService>()),
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
    () => LoginDataSourceImpl(sl<FirebaseAuthService>()),
  );
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(sl<LoginDataSource>()),
  );
  sl.registerLazySingleton<LoginWithEmailAndPasswordUseCase>(
    () => LoginWithEmailAndPasswordUseCase(sl<LoginRepository>()),
  );
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(sl<LoginWithEmailAndPasswordUseCase>()),
  );
}
