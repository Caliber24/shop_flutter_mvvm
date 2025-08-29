import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// viewmodels
import 'viewmodel/app_header_viewmodel.dart';

// screens
import 'screens/pre_home_loader.dart';

// providers
import 'providers/app_state_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/product_provider.dart';

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

  final apiService = ApiService();
  final auth = AuthProvider(apiService);
  await auth.loadFromStorage();

  runApp(
    MultiProvider(
      providers: [
        // Providers اصلی
        ChangeNotifierProvider(create: (_) => auth),
        ChangeNotifierProvider(create: (_) => AppStateProvider(auth)),
        ChangeNotifierProvider(create: (_) => AppHeaderViewModel()),

        // Providers داده‌ای
        ChangeNotifierProvider(create: (_) => CategoryProvider(apiService)),
        ChangeNotifierProvider(create: (_) => ProductProvider(apiService)),
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
