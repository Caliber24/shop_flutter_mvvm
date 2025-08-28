import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

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
    return jsonDecode(r.body);
  }

  Future<Map<String, dynamic>> get(
      String path, {
        Map<String, String>? headers,
      }) async {
    final r = await _client.get(
      Uri.parse('${Constants.baseUrl}$path'),
      headers: {'Content-Type': 'application/json', ...?headers},
    );
    _check(r);
    return jsonDecode(r.body);
  }

  void _check(http.Response r) {
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('HTTP ${r.statusCode}: ${r.body}');
    }
  }
}
