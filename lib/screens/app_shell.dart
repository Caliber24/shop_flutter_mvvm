import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widget/app_header.dart';
import '../utils/colors.dart';
import '../widget/app_bottom_nav.dart';
import '../viewmodel/app_header_viewmodel.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import '../screens/search_results.dart';

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

    _tabs = [
      HomeScreen(
        onSeeAllCategories: () {
          setState(() => _index = 1);
        },
      ),
      const CategoryScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final username = auth.me != null
        ? '${auth.me!.firstName} ${auth.me!.lastName}'
        : 'Guest';

    return ChangeNotifierProvider(
  create: (_) => AppHeaderViewModel(),
  child: Scaffold(
    backgroundColor: AppColors.background,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppHeader(
        username: username,
        onSearchNavigate: (query) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchResultsScreen(query: query),
            ),
          );
        },
      ),
    ),
    body: IndexedStack(
      index: _index,
      children: _tabs,
    ),
    bottomNavigationBar: AppBottomNav(
      currentIndex: _index,
      onTap: (i) => setState(() => _index = i),
    ),
  ),
)
;
  }
}
