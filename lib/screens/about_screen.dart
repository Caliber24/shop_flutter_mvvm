// صفحه درباره ما که شامل توضیحات و اطلاعات تماس هست
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      appBar: _AboutUsAppBar(),
      body: _AboutUsBody(),
    );
  }
}

class _AboutUsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AboutUsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'About Us',
        style: TextStyle(
          color: AppColors.yellowPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.background,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.yellowPrimary),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AboutUsBody extends StatelessWidget {
  const _AboutUsBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.yellowPrimary,
                width: 3,
              ),
            ),
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.itemBackground,
              backgroundImage: AssetImage('assets/images/team.png'),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Keshi & Pishro',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Developers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.yellowPrimary,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi "
                "ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit "
                "in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\n\n"
                "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia "
                "deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur "
                "adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. "
                "Sed nisi. Nulla quis sem at nibh elementum imperdiet.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: AppColors.gray,
            ),
          ),

          const SizedBox(height: 30),

          _ContactButton(
            icon: Icons.link,
            label: "www.mr-keshi.ir",
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ContactButton(
            icon: Icons.email_outlined,
            label: "mr.alireza.keshavarz@gmail.com",
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ContactButton(
            icon: Icons.email_outlined,
            label: "amirhosseinpishroa2001@gmail.com",
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ContactButton(
            icon: Icons.phone,
            label: "09907881747",
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ContactButton(
            icon: Icons.phone,
            label: "09164896609",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
//  جعبه اطلاعات تماس
class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.itemBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.yellowPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
