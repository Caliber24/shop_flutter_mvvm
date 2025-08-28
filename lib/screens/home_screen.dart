import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/colors.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // اگر از مسیر لاگین آمدیم و هنوز پروفایل لود نیست، اینجا بگیر
    final auth = context.read<AuthProvider>();
    if (auth.isLoggedIn && auth.me == null) {
      auth.fetchMe();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final me = auth.me;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.itemBackground,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (mounted) {
                context.read<AppStateProvider>().setStatus(AppStatus.loggedOut);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                      (_) => false,
                );
              }
            },
          ),
        ],
      ),
      body: me == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.yellowPrimary))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.itemBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grayBlack),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: me.image.isNotEmpty ? NetworkImage(me.image) : null,
                child: me.image.isEmpty ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${me.firstName} ${me.lastName}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(me.username, style: const TextStyle(color: AppColors.gray)),
                    const SizedBox(height: 4),
                    Text(me.email),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}