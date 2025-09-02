import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';

enum CategoryStatus { loading, loaded, error }

class CategoryProvider extends ChangeNotifier {
  final ApiService apiService;

  CategoryProvider(this.apiService) {
    _loadCategories();
  }

  CategoryStatus status = CategoryStatus.loading;
  List<Category> categories = [];
  String? errorMessage;

  Future<void> _loadCategories() async {
    status = CategoryStatus.loading;
    notifyListeners();

    try {
      categories = await apiService.fetchCategories();
      status = CategoryStatus.loaded;
    } catch (e) {
      categories = [];
      errorMessage = e.toString();
      status = CategoryStatus.error;
    }

    notifyListeners();
  }

  Future<void> refreshCategories() async {
    await _loadCategories();
  }
}
