import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../services/api_service.dart';
import '../widget/product_card.dart';
import '../utils/colors.dart';
import './product_detail_screen.dart';

class ProductsScreen extends StatelessWidget {
  final String categoryName;

  const ProductsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductProvider>(
      create: (_) => ProductProvider(ApiService(), category: categoryName),
      child: Consumer<ProductProvider>(
        builder: (context, vm, _) {
          if (vm.loading) {
            return const Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.yellowPrimary,
                ),
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

          if (vm.displayedProducts.isEmpty) {
            return const Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Text(
                  "No products found",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Text(categoryName),
              backgroundColor: AppColors.background,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.78,
                          ),
                      itemCount: vm.displayedProducts.length,
                      itemBuilder: (_, i) => ProductCard(
                        product: vm.displayedProducts[i],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(
                                productId: vm.displayedProducts[i].id,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // ---------------- Load More Button ----------------
                    if (vm.canLoadMore)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellowPrimary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: vm.loadMore,
                            child: const Text(
                              "Load More",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
