// lib/screens/all_products_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../viewmodel/all_products_viewmodel.dart';
import '../widget/product_card.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../utils/colors.dart';
import '../utils/category_icons.dart';
import 'product_detail_screen.dart';

class AllProductsScreen extends StatelessWidget {
  final List<Category>? categories; // اختیاری
  const AllProductsScreen({super.key, this.categories});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AllProductsViewModel>(
      create: (_) => AllProductsViewModel(ApiService()),
      child: _AllProductsView(categories: categories),
    );
  }
}

class _AllProductsView extends StatelessWidget {
  final List<Category>? categories;

  const _AllProductsView({this.categories});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AllProductsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<SortOption>(
            onSelected: vm.setSort,
            icon: const Icon(Icons.sort),
            itemBuilder: (_) => const [
              PopupMenuItem(value: SortOption.none, child: Text('No Sort')),
              PopupMenuItem(value: SortOption.priceLowHigh, child: Text('Price: Low → High')),
              PopupMenuItem(value: SortOption.priceHighLow, child: Text('Price: High → Low')),
              PopupMenuItem(value: SortOption.titleAZ, child: Text('Title: A → Z')),
              PopupMenuItem(value: SortOption.titleZA, child: Text('Title: Z → A')),
            ],
          ),
          IconButton(icon: const Icon(Icons.clear_all), onPressed: vm.clearFilters),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: vm.refresh,
          child: vm.loading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.yellowPrimary),
                )
              : vm.error != null
                  ? Center(
                      child: Text(
                        vm.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : Column(
                      children: [
                        // Search
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search products...",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: AppColors.itemBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: vm.setSearchQuery,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),

                        // Category filter فقط اگر دسته‌بندی موجود بود
                        if (categories != null && categories!.isNotEmpty)
                          SizedBox(
                            height: 70,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: categories!.length,
                              itemBuilder: (_, i) {
                                final cat = categories![i];
                                final selected = vm.selectedCategories.contains(cat.id);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ChoiceChip(
                                    label: Text(cat.name),
                                    selected: selected,
                                    onSelected: (_) => vm.toggleCategory(cat.id),
                                    backgroundColor: AppColors.itemBackground,
                                    selectedColor: AppColors.yellowPrimary,
                                    labelStyle: TextStyle(
                                      color: selected ? Colors.black : Colors.white,
                                    ),
                                    avatar: Icon(
                                      categoryIcons[cat.id] ?? Icons.category,
                                      size: 20,
                                      color: selected ? Colors.black : Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                        // Grid + Load More
                        Expanded(
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 0.78,
                                  ),
                                  itemCount: vm.filteredProducts.length,
                                  itemBuilder: (_, i) {
                                    final p = vm.filteredProducts[i];
                                    return ProductCard(
                                      product: p,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProductDetailScreen(productId: p.id),
                                          ),
                                        );
                                      },
                                      onAdd: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Added "${p.title}"')),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),

                              if (vm.canLoadMore)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.yellowPrimary,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: vm.loadMore,
                                      child: const Text(
                                        'Load more',
                                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

