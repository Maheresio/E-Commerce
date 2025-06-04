import 'package:e_commerce/core/services/firestore_sevice.dart';
import 'package:e_commerce/core/services/supabase_init.dart';
import 'package:e_commerce/features/auth/shared/data/service/firebase_auth_service_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/global/themes/dark/dark_theme.dart';
import 'core/global/themes/light/light_theme.dart';
import 'core/services/firebase_init.dart';
import 'core/services/service_locator.dart';
import 'core/routing/app_router.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await dotenv.load(fileName: ".env");
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



  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp.router(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
