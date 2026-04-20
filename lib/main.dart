// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controllers/app_bindings.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'services/hive_service.dart';
import 'services/mock_data_seeder.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Hive setup ─────────────────────────────────────────────────────────────
  await HiveService.init();
  await MockDataSeeder.seedIfEmpty(); // seeds only on first launch

  // ── UI system config ───────────────────────────────────────────────────────
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A1628),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const VidyenApp());
}

class VidyenApp extends StatelessWidget {
  const VidyenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VIDYEN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialBinding: AppBindings(),
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(
          name: AppRoutes.splash,
          page: () => const SplashScreen(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutes.login,
          page: () => const LoginScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: AppRoutes.register,
          page: () => const RegisterScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 280),
        ),
        GetPage(
          name: AppRoutes.dashboard,
          page: () => const DashboardScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ],
      defaultTransition: Transition.fadeIn,
    );
  }
}
