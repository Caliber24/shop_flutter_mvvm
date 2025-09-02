// ویجتی ساده برای نمایش آیتم‌های پروفایل با آیکون و عنوان.
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../utils/colors.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconBackground;
  final VoidCallback onTap;

  const ProfileListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.iconBackground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.itemBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(icon, color: Colors.white, size: 22),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
