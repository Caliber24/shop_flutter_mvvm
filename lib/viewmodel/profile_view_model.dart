//  مدیریت صفحه پروفایل کاربر
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/auth_provider.dart';
import '../screens/about_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/login_screen.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthProvider _auth;

  ProfileViewModel(this._auth);

  void onEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
  }

  void onAboutUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AboutUsScreen()),
    );
  }

  void onLorem(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lorem action tapped')),
    );
  }

  Future<void> onLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        title: const Text('Confirm logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Logout')),
        ],
      ),
    );

    if (ok == true) {
      await _auth.logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
    }
  }
}

class EditProfileViewModel extends ChangeNotifier {
  final AuthProvider _auth;

  EditProfileViewModel(this._auth);

  bool _loading = false;
  bool get loading => _loading;

  File? _imageFile;
  Uint8List? _imageWeb;

  File? get imageFile => _imageFile;
  Uint8List? get imageWeb => _imageWeb;

  void setImageFile(File? file) {
    _imageFile = file;
    _imageWeb = null;
    notifyListeners();
  }

  void setImageWeb(Uint8List? bytes) {
    _imageWeb = bytes;
    _imageFile = null;
    notifyListeners();
  }

  Future<void> _uploadProfileImage() async {
    final userId = _auth.me!.id;
    var request = http.MultipartRequest(
      'PATCH',
      Uri.parse('https://dummyjson.com/users/$userId'),
    );

    if (kIsWeb) {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        _imageWeb!,
        filename: 'profile.png',
      ));
    } else {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _imageFile!.path,
      ));
    }

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Image upload failed: ${response.statusCode}');
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    if (_auth.me == null) throw Exception('User not loaded');

    _loading = true;
    notifyListeners();

    try {
      if (_imageFile != null || _imageWeb != null) {
        await _uploadProfileImage();
      }

      await _auth.editProfile(
        firstName: firstName,
        lastName: lastName,
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
