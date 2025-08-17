import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/service_locator.dart';
import '../../features/auth/shared/presentation/bloc/auth_bloc.dart';

/// Wrapper widget that provides AuthBloc to its child widgets
///
/// This widget ensures that the AuthBloc is available throughout the
/// authentication flow without having to repeat provider setup.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key, required this.child});

  /// The child widget that needs access to AuthBloc
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => sl<AuthBloc>(), child: child);
  }
}
