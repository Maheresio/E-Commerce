import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:e_commerce/core/global/themes/app_theme_context.dart';
import 'package:e_commerce/core/responsive/responsive_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/global/themes/dark/dark_theme.dart';
import 'core/global/themes/light/light_theme.dart';
import 'core/routing/app_router.dart';
import 'core/services/firebase_init.dart';
import 'core/services/service_locator.dart';
import 'core/services/supabase_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await dotenv.load(fileName: ".env");
  await firebaseInit();
  await supabaseInit();
  serviceLocator();

  // final result = await SearchRemoteDataSourceImpl(
  //   dioClient: DioClient(),
  //   firestore: FirebaseFirestore.instance,
  //   storageService: SupabaseStorageService(),
  // ).getClothesTags(
  //   'https://rnyzefjhvgyoilciapuh.supabase.co/storage/v1/object/public/uploaded-images//1748838734504.jpg',
  // );

  // for (String tag in result) {
  //   print(tag);
  // }

  // for (var product in products) {
  //   debugPrint('product id: ${product.id}');
  //   final id = await FirestoreServices.instance.getPath();
  //   await FirestoreServices.instance.setData(
  //     path: FirestoreConstants.product(id),
  //     data: product.toMap(id),
  //   );
  // }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder:
          (context) => GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: lightTheme(context),
              darkTheme: darkTheme,
              themeMode: ThemeMode.system,
              routerConfig: AppRouter.router,
              builder:
                  (context, child) => ThemeContextInitializer(child: child!),
            ),
          ),
    );
  }
}
