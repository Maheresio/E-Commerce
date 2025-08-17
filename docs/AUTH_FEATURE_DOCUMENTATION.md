# Authentication Feature Documentation

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [API Reference](#api-reference)
- [Usage Guide](#usage-guide)
- [Testing](#testing)
- [Security](#security)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Overview

The Authentication Feature is a comprehensive, production-ready authentication system built using Clean Architecture principles. It provides secure user authentication through multiple providers including email/password and social authentication (Google, Facebook).

### Key Characteristics
- **Architecture**: Clean Architecture with clear separation of concerns
- **State Management**: BLoC pattern with optimized performance
- **Validation**: Comprehensive input validation with detailed error messages
- **Error Handling**: Robust error handling with custom failure types
- **Security**: Firebase Authentication integration with industry-standard security

### Supported Authentication Methods
- Email and Password
- Google Sign-In
- Facebook Sign-In
- Automatic session management

## Architecture

### Folder Structure
```
lib/features/auth/
├── login/
│   ├── data/
│   │   ├── datasources/
│   │   └── repositories/
│   ├── domain/
│   │   ├── repositories/
│   │   └── usecases/
│   └── presentation/
│       ├── bloc/
│       ├── views/
│       └── widgets/
├── register/
│   ├── data/
│   │   ├── datasources/
│   │   └── repositories/
│   ├── domain/
│   │   ├── repositories/
│   │   └── usecases/
│   └── presentation/
│       ├── bloc/
│       ├── views/
│       └── widgets/
└── shared/
    ├── data/
    │   ├── data_source/
    │   ├── models/
    │   └── repositories/
    ├── domain/
    │   ├── entity/
    │   ├── repositories/
    │   └── usecases/
    └── presentation/
        ├── bloc/
        └── widgets/
```

### Layer Responsibilities

#### 1. Domain Layer
- **Entities**: Core business objects (`UserEntity`, validation entities)
- **Repositories**: Abstract interfaces for data operations
- **Use Cases**: Business logic implementation

#### 2. Data Layer
- **Data Sources**: External data access (Firebase, APIs)
- **Models**: Data transfer objects
- **Repository Implementations**: Concrete repository implementations

#### 3. Presentation Layer
- **BLoC**: State management and business logic coordination
- **Views**: UI screens
- **Widgets**: Reusable UI components

## Features

### 1. Email/Password Authentication

#### Registration
- **Validation**: Comprehensive email, password, and name validation
- **Security**: Secure password requirements (8+ chars, special chars, etc.)
- **Error Handling**: Detailed validation feedback

#### Login
- **Validation**: Real-time input validation
- **Session Management**: Automatic session handling
- **Error Feedback**: User-friendly error messages

### 2. Social Authentication

#### Google Sign-In
- **Integration**: Firebase Google Auth integration
- **Profile Data**: Automatic profile information retrieval
- **Error Handling**: Graceful cancellation and error handling

#### Facebook Sign-In
- **Integration**: Firebase Facebook Auth integration
- **Permissions**: Minimal required permissions
- **Profile Sync**: Automatic user profile synchronization

### 3. Validation System

#### Email Validation
```dart
// Features:
- Empty field validation
- Format validation (RFC 5322 compliant)
- Domain validation
- Special character handling
- Internationalized domain support
```

#### Password Validation
```dart
// Requirements:
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one digit
- At least one special character
- No whitespace allowed
```

#### Name Validation
```dart
// Features:
- Length validation (2-50 characters)
- Character restrictions (letters, spaces, hyphens, apostrophes)
- Format validation
```

## API Reference

### Core Entities

#### UserEntity
```dart
class UserEntity {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;
}
```

### Use Cases

#### LoginWithEmailAndPasswordUseCase
```dart
Future<Either<Failure, void>> execute({
  required String email,
  required String password,
});
```

#### RegisterWithEmailAndPasswordUsecase
```dart
Future<Either<Failure, void>> execute({
  required String email,
  required String password,
  required String name,
});
```

#### SignInWithGoogleUseCase
```dart
Future<Either<Failure, UserEntity?>> call(NoParams params);
```

#### SignInWithFacebookUseCase
```dart
Future<Either<Failure, UserEntity?>> call(NoParams params);
```

### BLoC Events

#### LoginBloc Events
```dart
abstract class LoginEvent extends Equatable {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
}
```

#### RegisterBloc Events
```dart
abstract class RegisterEvent extends Equatable {}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String password;
  final String name;
}
```

#### AuthBloc Events
```dart
abstract class AuthEvent extends Equatable {}

class GoogleSignInRequested extends AuthEvent {}
class FacebookSignInRequested extends AuthEvent {}
```

### BLoC States

#### Login States
```dart
abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {}
class LoginFailure extends LoginState {
  final String message;
}
```

#### Register States
```dart
abstract class RegisterState extends Equatable {}

class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState {}
class RegisterFailure extends RegisterState {
  final String message;
}
```

#### Auth States
```dart
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final UserEntity user;
}
class AuthFailure extends AuthState {
  final String message;
}
```

### Repositories

#### AuthRepository
```dart
abstract class AuthRepository {
  Future<Either<Failure, UserEntity?>> signInWithGoogle();
  Future<Either<Failure, UserEntity?>> signInWithFacebook();
  Future<Either<Failure, void>> logOut();
  Stream<UserEntity?> get authStateChanges;
  Future<Either<Failure, UserEntity?>> getCurrentUserData();
}
```

#### LoginRepository
```dart
abstract class LoginRepository {
  Future<Either<Failure, void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}
```

#### RegisterRepository
```dart
abstract class RegisterRepository {
  Future<Either<Failure, void>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });
}
```

## Usage Guide

### 1. Setup Dependencies

Add to your `pubspec.yaml`:
```yaml
dependencies:
  firebase_auth: ^4.15.0
  google_sign_in: ^6.1.5
  flutter_facebook_auth: ^6.0.3
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  dartz: ^0.10.1
  get_it: ^7.6.4
```

### 2. Initialize Firebase

Follow Firebase setup instructions for your platform.

### 3. Register Dependencies

```dart
// In service_locator.dart
void serviceLocator() {
  // Core services
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  
  // Auth Feature dependencies
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestoreServices: sl<FirestoreServices>(),
    ),
  );
  
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthDataSource>()),
  );
  
  // ... other dependencies
}
```

### 4. Provide BLoCs

```dart
// In your app setup
MultiBlocProvider(
  providers: [
    BlocProvider<AuthBloc>(
      create: (context) => sl<AuthBloc>(),
    ),
    BlocProvider<LoginBloc>(
      create: (context) => sl<LoginBloc>(),
    ),
    BlocProvider<RegisterBloc>(
      create: (context) => sl<RegisterBloc>(),
    ),
  ],
  child: MyApp(),
)
```

### 5. Using Authentication in UI

#### Login Form
```dart
BlocConsumer<LoginBloc, LoginState>(
  listenWhen: (previous, current) {
    return current is LoginSuccess || current is LoginFailure;
  },
  listener: (context, state) {
    if (state is LoginSuccess) {
      // Handle success
      context.go(AppRouter.kNavBar);
    } else if (state is LoginFailure) {
      // Handle error
      showErrorMessage(state.message);
    }
  },
  buildWhen: (previous, current) {
    return (previous is LoginLoading) != (current is LoginLoading);
  },
  builder: (context, state) {
    return SubmitButton(
      isLoading: state is LoginLoading,
      onPressed: () {
        context.read<LoginBloc>().add(
          LoginButtonPressed(
            email: emailController.text,
            password: passwordController.text,
          ),
        );
      },
    );
  },
)
```

#### Social Authentication
```dart
StyledSocialButton(
  image: AppImages.google,
  onTap: () {
    context.read<AuthBloc>().add(const GoogleSignInRequested());
  },
)
```

### 6. Validation Usage

```dart
// Email validation
final emailValidation = EmailValidation(email);
emailValidation.value.fold(
  (failure) => showError(failure.message),
  (validEmail) => processValidEmail(validEmail),
);

// Password validation
final passwordValidation = PasswordValidation(password);
passwordValidation.value.fold(
  (failure) => showError(failure.message),
  (validPassword) => processValidPassword(validPassword),
);
```

## Testing

### Current Test Coverage

#### Unit Tests
- ✅ Email validation tests
- ✅ Password validation tests  
- ✅ Name validation tests

#### Missing Test Areas
- ❌ BLoC tests
- ❌ Use case tests
- ❌ Repository tests
- ❌ Integration tests

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/shared/domain/entity/email_validation_test.dart

# Run with coverage
flutter test --coverage
```

### Test Examples

#### Email Validation Test
```dart
test('should return right when email has valid format', () {
  const String email = 'test@example.com';
  final Either<Failure, String> result = 
      EmailValidation.validateEmail(email);
  expect(result, right('test@example.com'));
});
```

## Security

### Authentication Security Features

1. **Firebase Authentication**: Industry-standard security
2. **Input Validation**: Comprehensive validation prevents injection
3. **Password Requirements**: Strong password policy enforcement
4. **Error Handling**: No sensitive information leakage
5. **Session Management**: Automatic token refresh and validation

### Security Best Practices

1. **Never log sensitive information**
2. **Use HTTPS for all communications**
3. **Implement proper error handling**
4. **Regular security updates**
5. **Monitor authentication events**

### Common Security Considerations

```dart
// ✅ Good: Secure error handling
catch (FirebaseAuthException e) {
  return left(FirebaseFailure.fromCode(e.code));
}

// ❌ Bad: Exposing sensitive information
catch (FirebaseAuthException e) {
  return left(Failure(e.toString())); // May leak sensitive data
}
```

## Error Handling

### Error Types

#### Validation Errors
- Email format errors
- Password strength errors
- Name format errors

#### Authentication Errors
- Invalid credentials
- Network errors
- Firebase-specific errors

#### Custom Failure Types
```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
}

class FirebaseFailure extends Failure {
  static FirebaseFailure fromCode(String code) {
    switch (code) {
      case 'user-not-found':
        return const FirebaseFailure('No user found with this email.');
      case 'wrong-password':
        return const FirebaseFailure('Incorrect password.');
      // ... other cases
    }
  }
}
```

## Performance Optimizations

### BLoC Optimizations

The feature implements performance optimizations using `buildWhen` and `listenWhen`:

```dart
// Only rebuild when loading state changes
buildWhen: (previous, current) {
  return (previous is AuthLoading) != (current is AuthLoading);
}

// Only listen to success/failure states
listenWhen: (previous, current) {
  return current is AuthSuccess || current is AuthFailure;
}
```

### Benefits
- Reduced unnecessary rebuilds
- Improved UI responsiveness
- Better battery life
- Smoother animations

## Troubleshooting

### Common Issues

#### 1. Google Sign-In Not Working
```
Problem: Google sign-in fails silently
Solution: 
- Check SHA-1 fingerprint in Firebase Console
- Verify google-services.json is up to date
- Ensure Google Sign-In is enabled in Firebase
```

#### 2. Facebook Sign-In Issues
```
Problem: Facebook authentication fails
Solution:
- Verify Facebook App ID configuration
- Check Facebook App settings
- Ensure proper URL schemes are configured
```

#### 3. Validation Errors
```
Problem: Validation messages not showing
Solution:
- Check BlocListener implementation
- Verify error handling in UI
- Ensure proper state management
```

#### 4. Navigation Issues
```
Problem: Navigation not working after authentication
Solution:
- Check route configuration
- Verify context.mounted before navigation
- Ensure proper state handling
```

### Debugging Tips

1. **Enable Firebase Debug Logging**
```dart
FirebaseAuth.instance.setSettings(
  appVerificationDisabledForTesting: true,
);
```

2. **Log State Changes**
```dart
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      print('Login attempt for: ${event.email}');
      // ... rest of implementation
    });
  }
}
```

3. **Validate Configuration**
```bash
# Check Firebase configuration
flutter packages pub run firebase_core:version

# Verify dependencies
flutter doctor
```

## Contributing

### Code Style Guidelines

1. **Follow Clean Architecture principles**
2. **Use meaningful naming conventions**
3. **Write comprehensive tests**
4. **Document public APIs**
5. **Follow Dart style guide**

### Adding New Authentication Methods

1. **Create new use case in shared/domain/usecases/**
2. **Implement data source method**
3. **Add repository method**
4. **Create BLoC events/states**
5. **Implement UI components**
6. **Add comprehensive tests**

### Example: Adding Apple Sign-In

```dart
// 1. Use Case
class SignInWithAppleUseCase extends UseCase<UserEntity?, NoParams> {
  // Implementation
}

// 2. Repository method
Future<Either<Failure, UserEntity?>> signInWithApple();

// 3. BLoC event
class AppleSignInRequested extends AuthEvent {}

// 4. UI implementation
StyledSocialButton(
  image: AppImages.apple,
  onTap: () {
    context.read<AuthBloc>().add(const AppleSignInRequested());
  },
)
```

## Changelog

### Version History

#### v1.2.0 (Current)
- ✅ Added BLoC performance optimizations
- ✅ Improved error handling
- ✅ Enhanced validation messages

#### v1.1.0
- ✅ Added Facebook authentication
- ✅ Improved UI components
- ✅ Enhanced validation

#### v1.0.0
- ✅ Initial release
- ✅ Email/password authentication
- ✅ Google authentication
- ✅ Basic validation

## License

This authentication feature is part of the E-Commerce application. Please refer to the main project license for usage terms.

---

*Last updated: August 17, 2025*
*Version: 1.2.0*
