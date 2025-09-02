// صفحه ثبت نام در برنامه
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../viewmodel/signup_view_model.dart';
import '../widget/auth_widgets.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Consumer<SignUpViewModel>(
            builder: (context, vm, _) {
              final formKey = GlobalKey<FormState>();
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
                          child: Text("Sign up",
                              style: TextStyle(color: AppColors.yellowPrimary, fontWeight: FontWeight.w900, fontSize: 34)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FrostedCard(
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: vm.emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                decoration: authInput('Email', 'demo@email.com', icon: Icons.mail_outlined),
                                validator: (v) => (v!=null && v.contains('@')) ? null : 'Invalid email',
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: vm.usernameCtrl,
                                decoration: authInput('Username', 'your name', icon: Icons.person_outline),
                                validator: (v) => (v==null||v.isEmpty) ? 'please enter username' : null,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: vm.phoneCtrl,
                                keyboardType: TextInputType.phone,
                                decoration: authInput(
                                  'Phone no',
                                  '+1 900 000 0000',
                                  icon: Icons.phone_outlined,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                    return 'Only numbers are allowed';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: vm.passCtrl,
                                obscureText: vm.obscure1,
                                decoration: authInput('Password', 'min 6 chars', icon: Icons.lock_outline).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(vm.obscure1 ? Icons.visibility_off : Icons.visibility,
                                        color: AppColors.gray),
                                    onPressed: vm.toggle1,
                                  ),
                                ),
                                validator: (v) => v!=null && v.length>=6 ? null : 'min 6 chars',
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: vm.confirmCtrl,
                                obscureText: vm.obscure2,
                                decoration: authInput('Confirm Password', 'repeat password', icon: Icons.verified_user_outlined)
                                    .copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(vm.obscure2 ? Icons.visibility_off : Icons.visibility,
                                        color: AppColors.gray),
                                    onPressed: vm.toggle2,
                                  ),
                                ),
                                validator: (v) => v == vm.passCtrl.text ? null : 'At least 6 characters',
                              ),
                              const SizedBox(height: 16),
                              PrimaryButton(
                                text: vm.loading ? 'Please wait...' : 'Create Account',
                                icon: Icons.person_add_alt_1_rounded,
                                onPressed: vm.loading ? null : () async {
                                  if (!(formKey.currentState?.validate() ?? false)) return;
                                  await vm.submit(context);
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Already have an account? ', style: TextStyle(color: AppColors.gray)),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: const Text('Login',
                                        style: TextStyle(color: AppColors.yellowPrimary, fontWeight: FontWeight.w800)),
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
