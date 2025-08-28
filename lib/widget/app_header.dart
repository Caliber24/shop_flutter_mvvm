// lib/widget/app_header.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String subtitle;
  final String? avatarUrlOverride;

  const AppHeader({
    super.key,
    this.subtitle = 'We picked a theme for you',
    this.avatarUrlOverride,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final fullName = (auth.me != null)
        ? '${auth.me!.firstName} ${auth.me!.lastName}'.trim()
        : 'Guest';
    final avatar = avatarUrlOverride ??
        (auth.me?.image?.isNotEmpty == true ? auth.me!.image : null) ??
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=256&q=80';

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: const TextStyle(color: AppColors.gray, fontSize: 12)),
          const SizedBox(height: 2),
          Text(
            fullName.isEmpty ? 'User' : fullName,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            padding: const EdgeInsets.all(2), // ضخامت Border
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.yellowPrimary, width: 2),
            ),
            child: CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatar)),
          ),
        ),
      ],
    );
  }
}
