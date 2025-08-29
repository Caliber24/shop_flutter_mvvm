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

  Future<List<Category>> fetchCategories() async {
    final response = await _client.get(
      Uri.parse('https://dummyjson.com/products/categories'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (e) => Category(
              id: e['slug'].toString(), // یا هر فیلدی که یکتا هست
              name: e['name'].toString(),
            ),
          )
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // -------------------- Products --------------------

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final r = await get("/products/category/$category");
    final List data = r["products"] as List<dynamic>;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Product>> fetchPopularProducts({int limit = 12}) async {
    final r = await get(
      "/products?limit=$limit&select=title,price,rating,thumbnail",
    );
    final List data = r["products"] as List<dynamic>;
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
