import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';

// providers
import 'providers/app_state.dart';

// utils
import 'utils/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: RootScreen(),
    );
  }
}

class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);


    switch (appState.status) {
      case AppStatus.firstTime:
        return LoadingScreen();

      case AppStatus.loggedOut:
        return LoginScreen();

      case AppStatus.loading:
        return LoadingScreen();

      case AppStatus.loggedIn:
        return HomeScreen();
    }

    // حالت fallback (اینجا نباید برسه ولی برای جلوگیری از خطا)
    return Scaffold(
      body: Center(child: Text("Unknown state")),
    );
  }
}

