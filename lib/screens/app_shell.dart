import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/colors.dart';
import '../widget/app_header.dart';
import '../widget/app_bottom_nav.dart';

// tabs (content only)
import 'home_screen.dart';
import 'category_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    final auth = context.read<AuthProvider>();
    if (auth.isLoggedIn && auth.me == null) {
      auth.fetchMe();
    }
    _tabs = const [
    HomeScreen(),
      CategoryScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: IndexedStack(
        index: _index,
        children: _tabs,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
