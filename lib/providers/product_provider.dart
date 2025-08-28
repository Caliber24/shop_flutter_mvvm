import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _api;
  ProductProvider(this._api);

  List<Product> _popular = [];
  bool _loading = false;
  String? _error;

  List<Product> get popular => _popular;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadPopular({int limit = 12, bool force = false}) async {
    if (_loading) return;
    if (_popular.isNotEmpty && !force) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final j = await _api.get('/products?limit=$limit&select=title,price,rating,thumbnail');
      final List items = (j['products'] as List?) ?? [];
      _popular = items.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      _error = 'Failed to load products';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
