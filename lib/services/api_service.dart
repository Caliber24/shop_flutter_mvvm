// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/product.dart';
import '../utils/constants.dart';

class ApiService {
  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // -------------------- Generic Requests --------------------
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    final r = await _client.get(
      Uri.parse('${Constants.baseUrl}$path'),
      headers: {'Content-Type': 'application/json', ...?headers},
    );
    _check(r);
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final r = await _client.post(
      Uri.parse('${Constants.baseUrl}$path'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: jsonEncode(body),
    );
    _check(r);
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final r = await _client.put(
      Uri.parse('${Constants.baseUrl}$path'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: jsonEncode(body),
    );
    _check(r);
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<void> delete(String path, {Map<String, String>? headers}) async {
    final r = await _client.delete(
      Uri.parse('${Constants.baseUrl}$path'),
      headers: {'Content-Type': 'application/json', ...?headers},
    );
    _check(r);
  }

  // -------------------- Categories --------------------
  /// DummyJSON returns a JSON array of strings like:
  ///   ["smartphones","laptops", ...]
  /// بنابراین ما آن را به لیست Category تبدیل می‌کنیم
  Future<List<Category>> fetchCategories() async {
    final response = await _client.get(
      Uri.parse('${Constants.baseUrl}/products/categories'),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded.map<Category>((e) => Category.fromApi(e)).toList();
      } else {
        throw Exception('Unexpected categories response format');
      }
    } else {
      throw Exception(
        'Failed to load categories (status ${response.statusCode})',
      );
    }
  }

  // -------------------- Products --------------------

  /// گرفتن همه محصولات (با pagination)
  Future<List<Product>> fetchAllProducts({
    int limit = 100,
    int skip = 0,
  }) async {
    final r = await get("/products?limit=$limit&skip=$skip");
    final List data = (r["products"] ?? []) as List<dynamic>;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// گرفتن محصولات یک دسته (توجه: category باید slug باشد)
  Future<List<Product>> fetchProductsByCategory(
    String category, {
    int limit = 50,
    int skip = 0,
  }) async {
    final encoded = Uri.encodeComponent(category);
    final r = await get("/products/category/$encoded?limit=$limit&skip=$skip");
    final List data = (r["products"] ?? []) as List<dynamic>;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// محصولات محبوب (پیشنهادی)
  Future<List<Product>> fetchPopularProducts({int limit = 12}) async {
    final r = await get(
      "/products?limit=$limit&select=title,price,rating,thumbnail",
    );
    final List data = (r["products"] ?? []) as List<dynamic>;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // -------------------- Helper --------------------
  void _check(http.Response r) {
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('HTTP ${r.statusCode}: ${r.body}');
    }
  }
}
