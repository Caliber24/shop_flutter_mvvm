// ویجدت مربوط به ناوبار پایین
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.itemBackground,
        selectedItemColor: AppColors.yellowPrimary,
        unselectedItemColor: AppColors.gray,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded, size: 28),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded, size: 28),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded, size: 28),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
