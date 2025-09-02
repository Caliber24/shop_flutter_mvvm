// این کلاس مسئول مدیریت لیست کامل محصولات در صفحه "همه محصولات" است.
//  گرفتن لیست همه محصولات و دسته‌بندی‌ها از API.
//  جستجو در محصولات بر اساس عنوان.
// فیلتر،مرتب سازی ، افزودن به سبد خرید
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/category.dart' as cat;
import '../services/api_service.dart';

enum SortOption {
  none,
  priceLowHigh,
  priceHighLow,
  titleAZ,
  titleZA,
  ratingHighLow,
}

class AllProductsViewModel extends ChangeNotifier {
  final ApiService api;
  final List<cat.Category>? initialCategories;

  AllProductsViewModel(this.api, {this.initialCategories}) {
    _loadInitial();
  }

  List<Product> _all = [];
  List<Product> _displayed = [];
  List<cat.Category> _allCategories = [];
  bool _loading = false;
  String? _error;
  String _query = '';
  int _displayCount = 10;

  SortOption _sortOption = SortOption.none;
  Set<String> _selectedCategories = {};

  List<Product> get filteredProducts => _displayed;
  List<cat.Category> get allCategories => _allCategories;
  bool get loading => _loading;
  String? get error => _error;
  SortOption get sortOption => _sortOption;
  Set<String> get selectedCategories => _selectedCategories;
  bool get canLoadMore => _displayCount < _applyQuery(_all).length;

  Future<void> _loadInitial() async {
    _loading = true;
    notifyListeners();

    try {
      _allCategories = initialCategories ?? await api.fetchCategories();
      _all = await api.fetchAllProducts(limit: 200);
      _displayCount = 10;
      _updateDisplayed();
    } catch (e) {
      _error = 'Failed to load categories or products';
      _all = [];
      _displayed = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async => await _loadInitial();

  void setSearchQuery(String q) {
    _query = q.trim().toLowerCase();
    _displayCount = 10;
    _updateDisplayed();
    notifyListeners();
  }

  void setSort(SortOption option) {
    _sortOption = option;
    _updateDisplayed();
    notifyListeners();
  }

  Future<void> toggleCategory(String categoryId) async {
    if (_selectedCategories.contains(categoryId)) {
      _selectedCategories.remove(categoryId);
    } else {
      _selectedCategories.add(categoryId);
    }

    _displayCount = 10;
    _loading = true;
    notifyListeners();

    try {
      if (_selectedCategories.isEmpty) {
        _all = await api.fetchAllProducts(limit: 200);
      } else {
        final List<Product> list = [];
        for (var catId in _selectedCategories) {
          final prods = await api.fetchProductsByCategory(catId);
          list.addAll(prods);
        }
        _all = list;
      }
      _updateDisplayed();
    } catch (e) {
      _error = 'Failed to load products';
      _all = [];
      _displayed = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearFilters() async {
    _selectedCategories.clear();
    _sortOption = SortOption.none;
    _displayCount = 10;
    await toggleCategory('');
  }

  void loadMore() {
    if (!canLoadMore) return;
    _displayCount += 10;
    _updateDisplayed();
    notifyListeners();
  }

  List<Product> _applyQuery(List<Product> src) {
    var list = src;

    if (_query.isNotEmpty) {
      list = list.where((p) => p.title.toLowerCase().contains(_query)).toList();
    }

    switch (_sortOption) {
      case SortOption.priceLowHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.titleAZ:
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.titleZA:
        list.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortOption.ratingHighLow:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.none:
        break;
    }

    return list;
  }

  void _updateDisplayed() {
    final filtered = _applyQuery(_all);
    _displayed = filtered.take(_displayCount).toList();
  }
}
