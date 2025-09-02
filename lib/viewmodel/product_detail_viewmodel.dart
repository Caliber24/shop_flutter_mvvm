// ProductDetailViewModel: مدیریت اطلاعات جزئیات یک محصول

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ApiService api;
  final int productId;

  Product? _product;
  Product? get product => _product;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  ProductDetailViewModel(this.api, this.productId) {
    fetchProductDetail();
  }

  Future<void> fetchProductDetail() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final r = await api.get("/products/$productId");
      _product = Product.fromJson(r as Map<String, dynamic>);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
