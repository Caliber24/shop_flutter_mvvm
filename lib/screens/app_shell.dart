// این layout اصلی می باشد. صفحاتی که از طریق این لای اوت بارگذاری می شوند. هدر و فوتر یکسان دارند
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../viewmodel/cart_viewmodel.dart';
import '../viewmodel/app_header_viewmodel.dart';
import '../widget/app_header.dart';
import '../widget/app_bottom_nav.dart';
import '../utils/colors.dart';
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

    _tabs = [
      HomeScreen(onSeeAllCategories: () {
        setState(() => _index = 1);
      }),
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppHeaderViewModel()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppHeader(
            username: username,
            profileImageUrl: auth.me?.image ??
                'https://www.gravatar.com/avatar/placeholder?s=200&d=mp',
            onSearchNavigate: (query) {
              // TODO: implement search navigation
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
    );
  }
}
