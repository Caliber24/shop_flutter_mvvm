//  این کلاس هم همینطور که مشخص هست وظیفه ورود و خروج رو بر عهده دارد
// توکن هارو نگه داری مینه و درخواست ها رو مدیریت میکنه

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_tokens.dart';
import '../models/auth_user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthTokens? _tokens;
  AuthUser? _me;

  AuthTokens? get tokens => _tokens;
  AuthUser? get me => _me;
  bool get isLoggedIn => _tokens?.accessToken.isNotEmpty == true;

  AuthProvider(this._api);

  Future<void> loadFromStorage() async {
    final acc = await _storage.read(key: 'accessToken');
    final ref = await _storage.read(key: 'refreshToken');
    if (acc != null && ref != null) {
      _tokens = AuthTokens(accessToken: acc, refreshToken: ref);
    }

    final userJson = await _storage.read(key: 'me');
    if (userJson != null) {
      _me = AuthUser.fromJson(jsonDecode(userJson));
    }
    notifyListeners();
  }

  Future<void> _persistTokens(AuthTokens t) async {
    _tokens = t;
    await _storage.write(key: 'accessToken', value: t.accessToken);
    await _storage.write(key: 'refreshToken', value: t.refreshToken);
  }

  Future<void> login(String username, String password) async {
    try {
      final res = await _api.post('/auth/login', {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      });

      if (res == null || res['accessToken'] == null) {
        throw Exception('invalid_credentials');
      }

      final tokens = AuthTokens.fromJson(res);
      await _persistTokens(tokens);

      _me = AuthUser.fromJson(res);
      await _storage.write(key: 'me', value: jsonEncode(_me!.toJson()));
      notifyListeners();
    } catch (_) {
      throw Exception('invalid_credentials');
    }
  }

  Future<void> refreshTokens() async {
    if (_tokens == null) throw Exception('No refresh token found');
    final res = await _api.post('/auth/refresh', {
      'refreshToken': _tokens!.refreshToken,
      'expiresInMins': 30,
    });
    await _persistTokens(AuthTokens.fromJson(res));
    notifyListeners();
  }

  Future<void> fetchMe() async {
    if (_tokens == null) return;
    try {
      final j = await _api.get('/auth/me', headers: {
        'Authorization': 'Bearer ${_tokens!.accessToken}',
      });
      _me = AuthUser.fromJson(j);
      await _storage.write(key: 'me', value: jsonEncode(_me!.toJson()));
      notifyListeners();
    } catch (_) {
      try {
        await refreshTokens();
        final j = await _api.get('/auth/me', headers: {
          'Authorization': 'Bearer ${_tokens!.accessToken}',
        });
        _me = AuthUser.fromJson(j);
        await _storage.write(key: 'me', value: jsonEncode(_me!.toJson()));
        notifyListeners();
      } catch (e) {
        await logout();
        rethrow;
      }
    }
  }

  Future<void> editProfile({
    required String firstName,
    required String lastName,
    String? image,
  }) async {
    if (_me == null) throw Exception('User not loaded');
    final userId = _me!.id;

    final res = await _api.patch(
      '/users/$userId',
      {
        'firstName': firstName,
        'lastName': lastName,
        if (image != null) 'image': image,
      },
      headers: {'Content-Type': 'application/json'},
    );

    _me = _me!.copyWith(
      firstName: res['firstName'] ?? firstName,
      lastName: res['lastName'] ?? lastName,
    );
    await _storage.write(key: 'me', value: jsonEncode(_me!.toJson()));
    notifyListeners();
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    String? phone,
  }) async {
    await _api.post('/users/add', {
      'username': username,
      'email': email,
      'password': password,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    });
  }

  Future<void> logout() async {
    _tokens = null;
    _me = null;
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'me');
    notifyListeners();
  }
}
