import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../widget/category_pill.dart';
import '../utils/category_icons.dart';
import '../utils/colors.dart';
import 'product_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoryProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Categories"),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Builder(
        builder: (_) {
          if (vm.status == CategoryStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellowPrimary),
            );
          }

          if (vm.status == CategoryStatus.error) {
            return Center(
              child: Text(
                vm.errorMessage ?? "Unknown error",
                style: TextStyle(color: AppColors.yellowPrimary),
              ),
            );
          }

          if (vm.categories.isEmpty) {
            return Center(
              child: Text(
                "No categories found",
                style: TextStyle(color: AppColors.gray),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              // تعداد ستون‌ها بر اساس width
              final crossAxisCount = width >= 1200
                  ? 6
                  : width >= 900
                      ? 4
                      : width >= 600
                          ? 3
                          : 2;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: vm.categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0, // مربعی بودن pill‌ها
                  ),
                  itemBuilder: (context, index) {
                    final category = vm.categories[index];
                    return CategoryPill(
                      label: category.name,
                      icon: categoryIcons[category.id] ?? Icons.category,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductsScreen(categoryName: category.name),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
