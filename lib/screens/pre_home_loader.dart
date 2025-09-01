// lib/screens/pre_home_loader.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/app_state_provider.dart';
import '../utils/constants.dart';
import 'login_screen.dart';
import 'splash_screen.dart';
import 'app_shell.dart';

class PreHomeLoader extends StatefulWidget {
  const PreHomeLoader({super.key});

  @override
  State<PreHomeLoader> createState() => _PreHomeLoaderState();
}

class _PreHomeLoaderState extends State<PreHomeLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat();

    _boot();
  }

  Future<void> _waitUntilAppReady(AppStateProvider app, {Duration timeout = const Duration(seconds: 5)}) async {
    final start = DateTime.now();
    while (app.status == AppStatus.loading && DateTime.now().difference(start) < timeout) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _ensureMinSplash(DateTime start, Duration min) async {
    final elapsed = DateTime.now().difference(start);
    if (elapsed < min) {
      await Future.delayed(min - elapsed);
    }
  }

  Future<void> _boot() async {
    final auth = context.read<AuthProvider>();
    final app  = context.read<AppStateProvider>();

    final start = DateTime.now(); // شروع تایمر از همین لحظه

    await _waitUntilAppReady(app);

    Widget targetPage;

    try {
      final current = app.status;

      if (current == AppStatus.firstTime) {
        targetPage = SplashScreen();
      } else if (auth.isLoggedIn) {
        try {
          await auth.fetchMe();
          app.setStatus(AppStatus.loggedIn);
          targetPage =  const AppShell();
        } catch (_) {
          app.setStatus(AppStatus.loggedOut);
          targetPage = LoginScreen();
        }
      } else {
        app.setStatus(AppStatus.loggedOut);
        targetPage = LoginScreen();
      }
    } catch (_) {
      context.read<AppStateProvider>().setStatus(AppStatus.loggedOut);
      targetPage = LoginScreen();
    }

    // ✨ اینجا تضمین می‌کنیم حداقل ۴ ثانیه بگذره
    final elapsed = DateTime.now().difference(start);
    if (elapsed < Constants.minSplash) {
      await Future.delayed(Constants.minSplash - elapsed);
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => targetPage),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF202529), Color(0xFF16191B)],
            center: Alignment.center,
            radius: 1.0,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/logo.png", height: screenHeight * 0.25, fit: BoxFit.contain),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.yellow, Colors.orange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    child: const Text(
                      "Online Shop",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text("Your comfort, our priority", style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final offset = (index * 0.3);
                        final value = ((_controller.value + offset) % 1.0);
                        final dy = value < 0.5 ? -8.0 : 0.0;
                        final color = Color.lerp(Colors.orange, Colors.yellow, value)!;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: Transform.translate(offset: Offset(0, dy), child: _Dot(color: color)),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}