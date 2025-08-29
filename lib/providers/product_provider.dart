import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _api;
  final String? category; // اختیاری

  ProductProvider(this._api, {this.category}) {
    loadProducts();
  }

  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];
  bool _loading = false;
  String? _error;
  int _displayCount = 10;

  List<Product> get displayedProducts => _displayedProducts;
  bool get loading => _loading;
  String? get error => _error;
  bool get canLoadMore => _displayCount < _allProducts.length;

  Future<void> loadProducts({bool force = false}) async {
    if (_loading) return;
    if (_allProducts.isNotEmpty && !force) {
      _updateDisplayed();
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      List<Product> r;
      if (category == null) {
        r = await _api.fetchPopularProducts(limit: 50); // یا هر تعداد دلخواه
      } else {
        r = await _api.fetchProductsByCategory(category!);
      }
      _allProducts = r;
      _updateDisplayed();
    } catch (e) {
      _error = "Failed to load products";
      _displayedProducts = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void loadMore() {
    _displayCount += 10;
    _updateDisplayed();
    notifyListeners();
  }

  void _updateDisplayed() {
    _displayedProducts = _allProducts.take(_displayCount).toList();
  }
}
