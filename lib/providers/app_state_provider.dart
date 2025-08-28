import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_provider.dart';
import '../utils/constants.dart';

enum AppStatus { firstTime, loading, loggedOut, loggedIn }

class AppStateProvider extends ChangeNotifier {
  final AuthProvider auth;
  AppStatus status = AppStatus.loading;

  AppStateProvider(this.auth) {
    // همگام با AuthProvider
    auth.addListener(_onAuthChanged);
    _init();
  }

  void _onAuthChanged() {
    // اگر در مرحله‌ی onboarding نیستیم، بر اساس لاگین/لاگ‌اوت وضعیت بده
    if (status != AppStatus.firstTime) {
      final next = auth.isLoggedIn ? AppStatus.loggedIn : AppStatus.loggedOut;
      if (status != next) {
        status = next;
        notifyListeners();
      }
    }
  }

  Future<void> _init() async {
    // توکن‌ها و کاربر را از storage بخوان
    await auth.loadFromStorage();

    // مود دمو؟
    if (Constants.resetFirstTimeForDemo == true) {
      status = AppStatus.firstTime;
      notifyListeners();
      return;
    }

    // وضعیت first_time
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('first_time') ?? true;

    if (isFirstTime) {
      status = AppStatus.firstTime;
    } else {
      status = auth.isLoggedIn ? AppStatus.loggedIn : AppStatus.loggedOut;
    }
    notifyListeners();
  }

  Future<void> setFirstTimeDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);
    status = AppStatus.loggedOut; // بعد از onboarding -> صفحه لاگین
    notifyListeners();
  }

  void setStatus(AppStatus s) {
    status = s;
    notifyListeners();
  }

  @override
  void dispose() {
    auth.removeListener(_onAuthChanged);
    super.dispose();
  }
}