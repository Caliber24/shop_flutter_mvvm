import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../providers/auth_provider.dart';

class LoginViewModel extends ChangeNotifier {
  final usernameCtrl = TextEditingController(text: '');
  final passwordCtrl = TextEditingController(text: '');
  bool obscure = true;
  bool loading = false;

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }

  void _setLoading(bool v) {
    if (loading == v) return;
    loading = v;
    notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    _setLoading(true);

    try {
      await context.read<AuthProvider>().login(
        usernameCtrl.text.trim(),
        passwordCtrl.text,
      );

      if (!context.mounted) return;

      context.read<AppStateProvider>().setStatus(AppStatus.loggedIn);
    } catch (e) {
      if (context.mounted) {
        context.read<AppStateProvider>().setStatus(AppStatus.loggedOut);

        String msg = 'Login failed. Please try again.';
        if (e.toString().contains('invalid_credentials')) {
          msg = 'Incorrect username or password';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}