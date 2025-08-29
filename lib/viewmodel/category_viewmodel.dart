import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class CategoryViewModel extends ChangeNotifier {
  final ApiService apiService;

  CategoryViewModel({required this.apiService}) {
    loadCategories();
  }

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> loadCategories() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await apiService.fetchCategories();
    } catch (e) {
      _categories = [];
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
