// صفحه نمایش نتایج جستجوی محصولات.
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../widget/product_card.dart';
import 'product_detail_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late Future<List<Product>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = _searchProducts(widget.query);
  }

  Future<List<Product>> _searchProducts(String query) async {
    final api = ApiService();
    try {
      final r = await api.get(
        "/products/search?q=${Uri.encodeQueryComponent(query)}",
      );
      final List items = r['products'] as List? ?? [];
      return items
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search results for "${widget.query}"'),
        backgroundColor: Colors.black87,
      ),
      body: FutureBuilder<List<Product>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemCount: products.length,
            itemBuilder: (_, i) => ProductCard(
              product: products[i],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(
                      productId:
                          products[i].id,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
