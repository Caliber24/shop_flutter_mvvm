/// این کلاس وظیفه مدیریت وضعیت کلی اپلیکیشن رو برعهده داره.
/// وضعیت‌ها در قالب enum به نام [AppStatus] نگهداری میشن:
/// - firstTime → وقتی کاربر برای اولین بار اپلیکیشن رو باز می‌کنه.
/// - loading → زمانی که اپلیکیشن در حال بارگذاری اولیه هست.
/// - loggedOut → وقتی کاربر وارد نشده.
/// - loggedIn → وقتی کاربر وارد شده.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_provider.dart';
import '../utils/constants.dart';

enum AppStatus { firstTime, loading, loggedOut, loggedIn }

class AppStateProvider extends ChangeNotifier {
  final AuthProvider auth;
  AppStatus status = AppStatus.loading;

  AppStateProvider(this.auth) {
    auth.addListener(_onAuthChanged);
    _init();
  }

  void _onAuthChanged() {
    if (status != AppStatus.firstTime) {
      final next = auth.isLoggedIn ? AppStatus.loggedIn : AppStatus.loggedOut;
      if (status != next) {
        status = next;
        notifyListeners();
      }
    }
  }

  Future<void> _init() async {
    await auth.loadFromStorage();

    if (Constants.resetFirstTimeForDemo == true) {
      status = AppStatus.firstTime;
      notifyListeners();
      return;
    }

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
    status = AppStatus.loggedOut;
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