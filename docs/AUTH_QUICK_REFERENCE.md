# Authentication Feature - Quick Reference Guide

## 🚀 Quick Start

### Basic Setup
```dart
// 1. Add to pubspec.yaml
dependencies:
  firebase_auth: ^4.15.0
  flutter_bloc: ^8.1.3
  get_it: ^7.6.4

// 2. Initialize in main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  serviceLocator(); // Setup dependencies
  runApp(MyApp());
}

// 3. Provide BLoCs
MultiBlocProvider(
  providers: [
    BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
    BlocProvider<LoginBloc>(create: (context) => sl<LoginBloc>()),
    BlocProvider<RegisterBloc>(create: (context) => sl<RegisterBloc>()),
  ],
  child: MaterialApp(...),
)
```

## 📋 Common Use Cases

### 1. Email/Password Login
```dart
// In your login form
ElevatedButton(
  onPressed: () {
    context.read<LoginBloc>().add(
      LoginButtonPressed(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  },
  child: Text('Login'),
)

// Listen to state changes
BlocListener<LoginBloc, LoginState>(
  listener: (context, state) {
    if (state is LoginSuccess) {
      // Navigate to home
      context.go('/home');
    } else if (state is LoginFailure) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: YourUI(),
)
```

### 2. Social Authentication
```dart
// Google Sign-In
GestureDetector(
  onTap: () {
    context.read<AuthBloc>().add(const GoogleSignInRequested());
  },
  child: Container(
    child: Text('Sign in with Google'),
  ),
)

// Facebook Sign-In
GestureDetector(
  onTap: () {
    context.read<AuthBloc>().add(const FacebookSignInRequested());
  },
  child: Container(
    child: Text('Sign in with Facebook'),
  ),
)
```

### 3. User Registration
```dart
// Registration form
ElevatedButton(
  onPressed: () {
    context.read<RegisterBloc>().add(
      RegisterButtonPressed(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      ),
    );
  },
  child: Text('Register'),
)
```

### 4. Input Validation
```dart
// Email validation
final emailValidation = EmailValidation(email);
emailValidation.value.fold(
  (failure) => setState(() => emailError = failure.message),
  (validEmail) => setState(() => emailError = null),
);

// Password validation
final passwordValidation = PasswordValidation(password);
passwordValidation.value.fold(
  (failure) => setState(() => passwordError = failure.message),
  (validPassword) => setState(() => passwordError = null),
);

// Name validation
final nameValidation = NameValidation(name);
nameValidation.value.fold(
  (failure) => setState(() => nameError = failure.message),
  (validName) => setState(() => nameError = null),
);
```

## 🎯 BLoC Events Reference

### LoginBloc Events
```dart
// Trigger login
context.read<LoginBloc>().add(
  LoginButtonPressed(email: 'user@example.com', password: 'password123'),
);
```

### RegisterBloc Events
```dart
// Trigger registration
context.read<RegisterBloc>().add(
  RegisterButtonPressed(
    email: 'user@example.com',
    password: 'password123',
    name: 'John Doe',
  ),
);
```

### AuthBloc Events
```dart
// Google Sign-In
context.read<AuthBloc>().add(const GoogleSignInRequested());

// Facebook Sign-In
context.read<AuthBloc>().add(const FacebookSignInRequested());
```

## 📊 BLoC States Reference

### LoginStates
```dart
BlocBuilder<LoginBloc, LoginState>(
  builder: (context, state) {
    if (state is LoginInitial) {
      return LoginForm();
    } else if (state is LoginLoading) {
      return CircularProgressIndicator();
    } else if (state is LoginSuccess) {
      return SuccessMessage();
    } else if (state is LoginFailure) {
      return ErrorMessage(state.message);
    }
    return Container();
  },
)
```

### RegisterStates
```dart
BlocBuilder<RegisterBloc, RegisterState>(
  builder: (context, state) {
    if (state is RegisterInitial) {
      return RegisterForm();
    } else if (state is RegisterLoading) {
      return CircularProgressIndicator();
    } else if (state is RegisterSuccess) {
      return SuccessMessage();
    } else if (state is RegisterFailure) {
      return ErrorMessage(state.message);
    }
    return Container();
  },
)
```

### AuthStates
```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthInitial) {
      return SocialButtons();
    } else if (state is AuthLoading) {
      return CircularProgressIndicator();
    } else if (state is AuthSuccess) {
      return WelcomeMessage(state.user);
    } else if (state is AuthFailure) {
      return ErrorMessage(state.message);
    }
    return Container();
  },
)
```

## ⚡ Performance Optimizations

### Optimized BlocBuilder
```dart
BlocBuilder<LoginBloc, LoginState>(
  buildWhen: (previous, current) {
    // Only rebuild when loading state changes
    return (previous is LoginLoading) != (current is LoginLoading);
  },
  builder: (context, state) {
    return state is LoginLoading 
        ? CircularProgressIndicator()
        : LoginButton();
  },
)
```

### Optimized BlocListener
```dart
BlocListener<LoginBloc, LoginState>(
  listenWhen: (previous, current) {
    // Only listen to success/failure states
    return current is LoginSuccess || current is LoginFailure;
  },
  listener: (context, state) {
    if (state is LoginSuccess) {
      context.go('/home');
    } else if (state is LoginFailure) {
      showErrorSnackBar(state.message);
    }
  },
  child: YourWidget(),
)
```

### Optimized BlocConsumer
```dart
BlocConsumer<LoginBloc, LoginState>(
  listenWhen: (previous, current) {
    return current is LoginSuccess || current is LoginFailure;
  },
  buildWhen: (previous, current) {
    return (previous is LoginLoading) != (current is LoginLoading);
  },
  listener: (context, state) {
    // Handle side effects
  },
  builder: (context, state) {
    // Build UI
  },
)
```

## 🔒 Validation Rules

### Email Validation
- ✅ Not empty
- ✅ Valid email format (RFC 5322)
- ✅ Valid domain
- ✅ No consecutive dots
- ✅ Proper special character usage

### Password Validation
- ✅ Minimum 8 characters
- ✅ At least 1 uppercase letter
- ✅ At least 1 lowercase letter
- ✅ At least 1 digit
- ✅ At least 1 special character
- ✅ No whitespace

### Name Validation
- ✅ 2-50 characters
- ✅ Letters, spaces, hyphens, apostrophes only
- ✅ Proper format

## 🚨 Error Handling

### Common Error Patterns
```dart
// Repository error handling
try {
  final result = await dataSource.login(email, password);
  return right(result);
} on FirebaseAuthException catch (e) {
  return left(FirebaseFailure.fromCode(e.code));
} on SocketException catch (e) {
  return left(SocketFailure.fromMessage(e.message));
} catch (e) {
  return left(UnknownFailure(e.toString()));
}

// UI error handling
BlocListener<LoginBloc, LoginState>(
  listener: (context, state) {
    if (state is LoginFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: YourWidget(),
)
```

### Firebase Error Codes
```dart
// Common Firebase errors and their handling
switch (errorCode) {
  case 'user-not-found':
    return 'No user found with this email address.';
  case 'wrong-password':
    return 'Incorrect password. Please try again.';
  case 'email-already-in-use':
    return 'An account already exists with this email.';
  case 'weak-password':
    return 'Password is too weak. Please choose a stronger password.';
  case 'invalid-email':
    return 'Please enter a valid email address.';
  case 'user-disabled':
    return 'This account has been disabled.';
  case 'too-many-requests':
    return 'Too many attempts. Please try again later.';
  default:
    return 'An unexpected error occurred. Please try again.';
}
```

## 🧪 Testing Examples

### Unit Test Example
```dart
group('EmailValidation', () {
  test('should return right when email is valid', () {
    // Arrange
    const email = 'test@example.com';
    
    // Act
    final result = EmailValidation.validateEmail(email);
    
    // Assert
    expect(result, right('test@example.com'));
  });

  test('should return left when email is invalid', () {
    // Arrange
    const email = 'invalid-email';
    
    // Act
    final result = EmailValidation.validateEmail(email);
    
    // Assert
    expect(result, isA<Left<Failure, String>>());
  });
});
```

### BLoC Test Example
```dart
group('LoginBloc', () {
  late MockLoginUseCase mockLoginUseCase;
  late LoginBloc loginBloc;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginBloc = LoginBloc(mockLoginUseCase);
  });

  blocTest<LoginBloc, LoginState>(
    'emits [LoginLoading, LoginSuccess] when login succeeds',
    build: () {
      when(() => mockLoginUseCase.execute(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => right(null));
      
      return loginBloc;
    },
    act: (bloc) => bloc.add(
      LoginButtonPressed(email: 'test@example.com', password: 'password123'),
    ),
    expect: () => [LoginLoading(), LoginSuccess()],
  );
});
```

## 📱 UI Components

### Styled Form Input
```dart
class StyledTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
```

### Submit Button with Loading
```dart
class SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading 
          ? CircularProgressIndicator()
          : Text(text),
    );
  }
}
```

## 🔗 Navigation Integration

### GoRouter Setup
```dart
// Route configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeView(),
    ),
  ],
);

// Navigation after successful authentication
if (state is LoginSuccess) {
  context.go('/home');
}
```

## 🛠️ Troubleshooting

### Common Issues & Solutions

#### Issue: Google Sign-In not working
```bash
# Solution: Check SHA-1 fingerprint
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Add the SHA-1 to Firebase Console
```

#### Issue: Facebook Sign-In fails
```dart
// Check Facebook App ID in AndroidManifest.xml
<meta-data 
    android:name="com.facebook.sdk.ApplicationId" 
    android:value="@string/facebook_app_id"/>

// Verify URL schemes in Info.plist (iOS)
<key>CFBundleURLSchemes</key>
<array>
    <string>fb{your-app-id}</string>
</array>
```

#### Issue: Validation not working
```dart
// Ensure proper validation usage
final emailValidation = EmailValidation(email);
if (emailValidation.value.isLeft()) {
  // Handle validation error
  final failure = emailValidation.value.fold(
    (failure) => failure,
    (success) => null,
  );
  print('Validation error: ${failure?.message}');
}
```

#### Issue: BLoC not updating UI
```dart
// Check if context.read<Bloc>() is used correctly
context.read<LoginBloc>().add(LoginButtonPressed(...));

// Ensure BlocProvider is properly set up
BlocProvider<LoginBloc>(
  create: (context) => sl<LoginBloc>(),
  child: LoginView(),
)

// Verify buildWhen/listenWhen conditions
buildWhen: (previous, current) {
  // Make sure this returns true when UI should update
  return previous.runtimeType != current.runtimeType;
}
```

## 📦 Dependencies

### Required Dependencies
```yaml
dependencies:
  # Core
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Authentication
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.0
  google_sign_in: ^6.1.5
  flutter_facebook_auth: ^6.0.3
  
  # Functional Programming
  dartz: ^0.10.1
  
  # Navigation
  go_router: ^12.1.3

dev_dependencies:
  # Testing
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mocktail: ^1.0.1
```

---

*This quick reference guide provides the most commonly used patterns and solutions for the authentication feature.*
