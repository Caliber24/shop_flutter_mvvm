// صفحه پروفایل که در آن ویدجت های درباره ما و ویرایش پروفایل + لاگ اوت وجود دارد
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../utils/colors.dart';
import '../../providers/auth_provider.dart';

import '../viewmodel/profile_view_model.dart';
import '../widget/profile_list_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return ChangeNotifierProvider<ProfileViewModel>(
      create: (_) => ProfileViewModel(auth),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context, listen: false);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            ProfileListItem(
              icon: LucideIcons.user,
              title: 'Edit Profile',
              iconBackground: AppColors.yellowPrimary,
              onTap: () => vm.onEditProfile(context),
            ),
            ProfileListItem(
              icon: LucideIcons.info,
              title: 'About Us',
              iconBackground: const Color(0xFF6EE7B7),
              onTap: () => vm.onAboutUs(context),
            ),
            ProfileListItem(
              icon: LucideIcons.fileText,
              title: 'Lorem Ipsum',
              iconBackground: const Color(0xFF2631FF),
              onTap: () => vm.onLorem(context),
            ),
            ProfileListItem(
              icon: LucideIcons.logOut,
              title: 'Logout',
              iconBackground: const Color(0xFFEF5350),
              onTap: () => vm.onLogout(context),
            ),
            const Spacer(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
