// صفحه اصلی
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../services/api_service.dart';
import '../utils/colors.dart';
import '../widget/product_card.dart';
import '../widget/section_header.dart';
import '../widget/category_pill.dart';
import 'product_screen.dart';
import 'product_detail_screen.dart';
import '../models/category.dart';
import '../utils/category_icons.dart';
import 'all_product_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onSeeAllCategories;

  const HomeScreen({super.key, this.onSeeAllCategories});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late Future<List<Category>> _categoriesFuture;
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService().fetchCategories();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (_) => ProductProvider(ApiService()),
        child: Consumer<ProductProvider>(
          builder: (_, vm, __) {
            return ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (_, __) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6A00), Color(0xFFFFC700)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(_glowAnimation.value),
                                  blurRadius: 30,
                                  spreadRadius: 8,
                                ),
                                BoxShadow(
                                  color: Colors.red.withOpacity(_glowAnimation.value / 2),
                                  blurRadius: 60,
                                  spreadRadius: 12,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '🔥 Mega Hot Deal 🔥',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellowAccent,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 18,
                                      color: Colors.redAccent.withOpacity(0.8),
                                      offset: const Offset(0, 0),
                                    ),
                                    Shadow(
                                      blurRadius: 24,
                                      color: Colors.orangeAccent.withOpacity(0.6),
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Up to 75% OFF on selected items',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 14,
                                      color: Colors.orangeAccent.withOpacity(0.7),
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                SectionHeader(
                  'Product Categories',
                  actionText: 'See all',
                  onActionTap: widget.onSeeAllCategories,
                ),
                SizedBox(
                  height: 110,
                  child: FutureBuilder<List<Category>>(
                    future: _categoriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)),
                        );
                      }

                      final categories = snapshot.data ?? [];
                      if (categories.isEmpty) {
                        return const Center(child: Text("No categories found", style: TextStyle(color: Colors.white)));
                      }

                      final displayCategories = categories.length > 7 ? categories.sublist(0, 7) : categories;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: displayCategories.length,
                        itemBuilder: (_, index) {
                          final cat = displayCategories[index];
                          return CategoryPill(
                            icon: categoryIcons[cat.id] ?? Icons.category,
                            label: cat.name,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ProductsScreen(categoryName: cat.name)),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                SectionHeader(
                  'Popular Products',
                  actionText: 'View all',
                  onActionTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AllProductsScreen()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: vm.loading
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator(color: AppColors.yellowPrimary)),
                  )
                      : vm.error != null
                      ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text(vm.error!, style: const TextStyle(color: Colors.red))),
                  )
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: vm.displayedProducts.length.clamp(0, 10),
                    itemBuilder: (_, i) => ProductCard(
                      product: vm.displayedProducts[i],
                      onTap: () async {
                        final result = await Navigator.push<bool?>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(productId: vm.displayedProducts[i].id),
                          ),
                        );

                        if (result == true && mounted) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
