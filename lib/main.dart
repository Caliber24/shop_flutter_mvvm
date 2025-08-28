import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// screens
import 'screens/pre_home_loader.dart';

// providers
import 'providers/app_state_provider.dart';
import 'providers/auth_provider.dart';

// services
import 'services/api_service.dart';

// utils
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // دمو: ریست first_time (اختیاری)
  const bool RESET_FIRST_TIME_FOR_DEMO = false;
  if (RESET_FIRST_TIME_FOR_DEMO) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('first_time');
  }

  final auth = AuthProvider(ApiService());
  await auth.loadFromStorage(); // اوکیه، AppStateProvider هم load می‌کند؛ مشکلی ایجاد نمی‌شود.

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => auth),
        ChangeNotifierProvider(create: (_) => AppStateProvider(auth)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const PreHomeLoader(),
    );
  }
}
