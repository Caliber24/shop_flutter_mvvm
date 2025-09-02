// SignUpViewModel: مدیریت فرم ثبت‌نام، شامل کنترلرهای ورودی، وضعیت بارگذاری (loading) و امکان نمایش/مخفی کردن پسورد.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class SignUpViewModel extends ChangeNotifier {
  final emailCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;
  bool loading = false;

  void toggle1() { obscure1 = !obscure1; notifyListeners(); }
  void toggle2() { obscure2 = !obscure2; notifyListeners(); }

  Future<void> submit(BuildContext context) async {
    loading = true; notifyListeners();
    try {
      await context.read<AuthProvider>().signUp(
        username: usernameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
        phone: phoneCtrl.text.trim(),
      );
      if (context.mounted) {
        loading = false; notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful. Please login.')),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) Navigator.pop(context);
      }
    } catch (e) {
      loading = false; notifyListeners();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Signup failed: $e')));
      }
    }
  }
}

class SplashViewModel extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  final PageController pageController = PageController();

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}

