import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

enum SortOption { none, priceLowHigh, priceHighLow, titleAZ, titleZA }

class AllProductsViewModel extends ChangeNotifier {
  final ApiService api;

  AllProductsViewModel(this.api) {
    _loadInitial();
  }

  List<Product> _all = [];
  List<Product> _displayed = [];
  bool _loading = false;
  String? _error;
  String _query = '';
  int _displayCount = 10;

  // Sort & Filter
  SortOption _sortOption = SortOption.none;
  Set<String> _selectedCategories = {};

  // getters
  List<Product> get products => _all;
  List<Product> get filteredProducts => _displayed;
  bool get loading => _loading;
  String? get error => _error;
  SortOption get sortOption => _sortOption;
  Set<String> get selectedCategories => _selectedCategories;
  bool get canLoadMore {
    final filtered = _applyQuery(_all);
    return _displayCount < filtered.length;
  }

  Future<void> _loadInitial() async {
    await loadAll(force: true);
  }

  Future<void> loadAll({bool force = false}) async {
    if (_loading) return;
    if (_all.isNotEmpty && !force) {
      _updateDisplayed();
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final list = await api.fetchAllProducts(limit: 200);
      _all = list;
      _displayCount = 10;
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

  Future<void> refresh() async {
    await loadAll(force: true);
  }

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

  void toggleCategory(String categoryId) {
    if (_selectedCategories.contains(categoryId)) {
      _selectedCategories.remove(categoryId);
    } else {
      _selectedCategories.add(categoryId);
    }
    _displayCount = 10;
    _updateDisplayed();
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategories.clear();
    _sortOption = SortOption.none;
    _displayCount = 10;
    _updateDisplayed();
    notifyListeners();
  }

  void loadMore() {
    if (!canLoadMore) return;
    _displayCount += 10;
    _updateDisplayed();
    notifyListeners();
  }

  List<Product> _applyQuery(List<Product> src) {
    var list = src;

    // Search
    if (_query.isNotEmpty) {
      list = list.where((p) => p.title.toLowerCase().contains(_query)).toList();
    }

    // Filter by category
    if (_selectedCategories.isNotEmpty) {
      list = list.where((p) => _selectedCategories.contains(p.categoryId)).toList();
    }

    // Sort
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
