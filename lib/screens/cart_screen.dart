import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text('Cart', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}
