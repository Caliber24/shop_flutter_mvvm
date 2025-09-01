import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/all_products_viewmodel.dart';
import '../widget/product_card.dart';
import '../models/category.dart';
import '../utils/colors.dart';
import '../utils/category_icons.dart';
import 'product_detail_screen.dart';
import '../services/api_service.dart';
import '../viewmodel/cart_viewmodel.dart';

class AllProductsScreen extends StatelessWidget {
  final List<Category>? categories;
  const AllProductsScreen({super.key, this.categories});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              AllProductsViewModel(ApiService(), initialCategories: categories),
        ),
        ChangeNotifierProvider(
          create: (_) => CartViewModel(),
        ),
      ],
      child: const _AllProductsView(),
    );
  }
}

class _AllProductsView extends StatefulWidget {
  const _AllProductsView({super.key});

  @override
  State<_AllProductsView> createState() => _AllProductsViewState();
}

class _AllProductsViewState extends State<_AllProductsView> {
  bool searchMode = false;
  final TextEditingController searchController = TextEditingController();

  void _startSearch() => setState(() => searchMode = true);

  void _exitSearch() {
    searchController.clear();
    setState(() => searchMode = false);
    context.read<AllProductsViewModel>().setSearchQuery('');
  }

  void _openSortSheet(AllProductsViewModel vm) {
    showModalBottomSheet(
      backgroundColor: AppColors.background,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: SortOption.values.map((option) {
            final selected = vm.sortOption == option;
            String title;
            switch (option) {
              case SortOption.none:
                title = 'No Sort';
                break;
              case SortOption.priceLowHigh:
                title = 'Price: Low → High';
                break;
              case SortOption.priceHighLow:
                title = 'Price: High → Low';
                break;
              case SortOption.titleAZ:
                title = 'Title: A → Z';
                break;
              case SortOption.titleZA:
                title = 'Title: Z → A';
                break;
              case SortOption.ratingHighLow:
                title = 'Rating: High → Low';
                break;
            }
            return ListTile(
              title: Text(title, style: const TextStyle(color: Colors.white)),
              trailing: selected ? const Icon(Icons.check, color: Colors.yellow) : null,
              onTap: () {
                vm.setSort(option);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AllProductsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (searchMode) {
              _exitSearch();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: searchMode ? Colors.white.withOpacity(0.3) : Colors.transparent,
            ),
          ),
          child: TextField(
            controller: searchController,
            onChanged: vm.setSearchQuery,
            onTap: _startSearch,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              hintText: 'Search...',
              hintStyle: const TextStyle(color: Colors.white60),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
              suffixIcon: searchMode
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white70),
                      onPressed: _exitSearch,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.white),
            onPressed: () => _openSortSheet(vm),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: vm.refresh,
        child: vm.loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.yellowPrimary))
            : vm.error != null
                ? Center(
                    child: Text(vm.error!, style: const TextStyle(color: Colors.red)))
                : CustomScrollView(
                    slivers: [
                      // Categories
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 70,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: vm.allCategories.length,
                            itemBuilder: (_, i) {
                              final cat = vm.allCategories[i];
                              final selected = vm.selectedCategories.contains(cat.id);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(cat.name),
                                  avatar: Icon(
                                    categoryIcons[cat.id] ?? Icons.category,
                                    size: 20,
                                    color: selected ? Colors.black : Colors.white,
                                  ),
                                  selected: selected,
                                  onSelected: (_) => vm.toggleCategory(cat.id),
                                  backgroundColor: AppColors.itemBackground,
                                  selectedColor: AppColors.yellowPrimary,
                                  labelStyle: TextStyle(
                                    color: selected ? Colors.black : Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Products grid
                      SliverPadding(
                        padding: const EdgeInsets.all(12),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = vm.filteredProducts[index];
                              return ProductCard(
                                product: product,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailScreen(productId: product.id),
                                  ),
                                ),
                              );
                            },
                            childCount: vm.filteredProducts.length,
                          ),
                        ),
                      ),
                      // Load more button
                      if (vm.canLoadMore)
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverToBoxAdapter(
                            child: SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: vm.loadMore,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.yellowPrimary,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Load more",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}
