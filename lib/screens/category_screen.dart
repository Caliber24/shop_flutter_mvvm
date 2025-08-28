import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text('Categories', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}
