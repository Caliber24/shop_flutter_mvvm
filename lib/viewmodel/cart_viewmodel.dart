import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartViewModel extends ChangeNotifier {
  final Map<int, CartItem> _items = {};
  static const _storageKey = 'cart_items';

  CartViewModel() {
    _loadFromPrefs();
  }

  List<CartItem> get items => _items.values.toList();
  int get totalItems => _items.values.fold(0, (sum, e) => sum + e.quantity);
  double get totalPrice => _items.values.fold(0, (sum, e) => sum + e.totalPrice);
  bool get isEmpty => _items.isEmpty;

  void addProduct(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    _saveToPrefs();
    notifyListeners();
  }

  void removeOne(Product product) {
    if (!_items.containsKey(product.id)) return;
    if (_items[product.id]!.quantity > 1) {
      _items[product.id]!.quantity -= 1;
    } else {
      _items.remove(product.id);
    }
    _saveToPrefs();
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product.id);
    _saveToPrefs();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _saveToPrefs();
    notifyListeners();
  }

  // ذخیره در SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final map = _items.map((key, value) => MapEntry(key.toString(), {
          'id': value.product.id,
          'title': value.product.title,
          'thumbnail': value.product.thumbnail,
          'price': value.product.price,
          'rating': value.product.rating,
          'quantity': value.quantity,
        }));
    prefs.setString(_storageKey, jsonEncode(map));
  }

  // بارگذاری از SharedPreferences
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_storageKey)) return;
    final jsonStr = prefs.getString(_storageKey)!;
    final Map<String, dynamic> map = jsonDecode(jsonStr);
    _items.clear();
    map.forEach((key, value) {
      final product = Product(
        id: value['id'],
        title: value['title'],
        thumbnail: value['thumbnail'],
        description: value,
        price: value['price'],
        rating: value['rating'].toDouble(),
      );
      _items[product.id] = CartItem(product: product, quantity: value['quantity']);
    });
    notifyListeners();
  }
}
