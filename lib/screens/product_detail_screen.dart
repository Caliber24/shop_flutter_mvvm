// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/product_detail_viewmodel.dart';
import '../services/api_service.dart';
import '../utils/colors.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductDetailViewModel>(
      create: (_) => ProductDetailViewModel(ApiService(), productId),
      child: Consumer<ProductDetailViewModel>(
        builder: (context, vm, _) {
          if (vm.loading) {
            return const Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.yellowPrimary),
              ),
            );
          }

          if (vm.error != null) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Text(
                  vm.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final product = vm.product!;
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Text(product.title),
              backgroundColor: AppColors.background,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // تصویر اصلی
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      product.thumbnail,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.grayBlack,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image_rounded, color: Colors.white54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // عنوان محصول
                  Text(
                    product.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // امتیاز
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // قیمت
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.yellowPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '€${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // توضیحات
                  Text(
                    product.description ?? 'No description available',
                    style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellowPrimary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
