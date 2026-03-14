import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/user_local_service.dart';
import 'core/theme/colors.dart';
import 'features/onboarding/presentation/pages/onboarding_splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive (uses app documents dir on all platforms)
  await Hive.initFlutter();
  await UserLocalService.init();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final bool hasUser = UserLocalService.hasUser();

  runApp(MainApp(hasUser: hasUser));
}

class MainApp extends StatelessWidget {
  final bool hasUser;
  const MainApp({super.key, required this.hasUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.cardBackground,
        ),
        fontFamily: 'sans-serif',
      ),
      // If user already exists → go to home (placeholder); else → splash → onboarding
      home: const OnboardingSplashPage(),
    );
  }
}
