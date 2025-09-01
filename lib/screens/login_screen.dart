import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_mvvm/screens/app_shell.dart';
import '../providers/app_state_provider.dart';
import '../utils/colors.dart';
import '../viewmodel/login_view_model.dart';
import '../widget/auth_widgets.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Consumer<LoginViewModel>(
            builder: (context, vm, _) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CurvedHeader(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              color: AppColors.yellowPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FrostedCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: vm.usernameCtrl,
                                decoration: authInput('Username', 'demo user', icon: Icons.person_outline),
                                validator: (v) => (v == null || v.isEmpty) ? 'please enter username' : null,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: vm.passwordCtrl,
                                obscureText: vm.obscure,
                                enableSuggestions: false,
                                autocorrect: false,
                                autofillHints: const [AutofillHints.password],
                                decoration: authInput('Password', '••••••••', icon: Icons.lock_outline).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      vm.obscure ? Icons.visibility_off : Icons.visibility,
                                      color: AppColors.gray,
                                    ),
                                    onPressed: vm.toggleObscure,
                                  ),
                                ),
                                validator: (v) => (v == null || v.length < 4) ? 'Password is too short' : null,
                              ),
                              const SizedBox(height: 10),
                              PrimaryButton(
                                text: vm.loading ? 'Please wait...' : 'Login',
                                icon: Icons.login_rounded,
                                onPressed: () async {
                                  if (vm.loading) return;
                                  if (!(_formKey.currentState?.validate() ?? false)) return;

                                  await vm.submit(context);

                                  if (context.mounted &&
                                      context.read<AppStateProvider>().status == AppStatus.loggedIn) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const AppShell()),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Don\'t have an account? ', style: TextStyle(color: AppColors.gray)),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                                    ),
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(color: AppColors.yellowPrimary, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}