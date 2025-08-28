// lib/widget/app_bottom_nav.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12), // فاصله از بالا
      child: ClipRRect(
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
              icon: SizedBox(
                height: 32, // 👈 ارتفاع بیشتر
                width: 32,
                child: Icon(Icons.home_rounded, size: 22),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 32,
                width: 32,
                child: Icon(Icons.category_rounded, size: 22),
              ),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 32,
                width: 32,
                child: Icon(Icons.shopping_cart_rounded, size: 22),
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 32,
                width: 32,
                child: Icon(Icons.person_rounded, size: 22),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
  }
