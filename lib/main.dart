import 'core/global/themes/app_theme_context.dart';
import 'core/responsive/responsive_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'core/global/themes/dark/dark_theme.dart';
import 'core/global/themes/light/light_theme.dart';
import 'core/routing/app_router.dart';
import 'core/services/firebase_init.dart';
import 'core/services/service_locator.dart';
import 'core/services/supabase_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await dotenv.load();
  await firebaseInit();
  await supabaseInit();
  serviceLocator();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  await Stripe.instance.applySettings();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ResponsiveApp(
      builder:
          ( context) => GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: lightTheme(context),
              darkTheme: darkTheme,
              routerConfig: AppRouter.router,
              builder:
                  (context, child) => ThemeContextInitializer(child: child!),
            ),
          ),
    );
}
