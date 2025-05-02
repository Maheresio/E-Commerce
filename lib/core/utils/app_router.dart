import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login/presentation/bloc/login_bloc.dart';
import '../../features/auth/login/presentation/views/login_view.dart';
import '../../features/auth/register/presentation/bloc/register_bloc.dart';
import '../../features/auth/register/presentation/views/register_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../services/service_locator.dart';

abstract class AppRouter {
  static const kRegister = '/register';
  static const kLogin = '/kLogin';
  static const kHome = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: kHome,
    routes: [
      GoRoute(
        path: kLogin,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<LoginBloc>(),
            child: LoginView(),
          );
        },
      ),
      GoRoute(
        path: kRegister,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<RegisterBloc>(),
            child: RegisterView(),
          );
        },
      ),
      GoRoute(path: kHome, builder: (context, state) => HomeView()),
    ],
  );
}
