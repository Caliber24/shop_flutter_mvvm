// صفحه مربوط به ویرایش پروفایل کاربر
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../viewmodel/profile_view_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';

  Future<void> _pickImage(EditProfileViewModel vm) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        vm.setImageWeb(bytes);
      } else {
        vm.setImageFile(File(picked.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.me;

    return ChangeNotifierProvider(
      create: (_) => EditProfileViewModel(auth),
      child: Consumer<EditProfileViewModel>(
        builder: (context, vm, _) => Scaffold(
          appBar: AppBar(title: const Text('Edit Profile')),
          body: user == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: kIsWeb
                              ? (vm.imageWeb != null
                              ? MemoryImage(vm.imageWeb!)
                              : (user.image.isNotEmpty
                              ? NetworkImage(user.image)
                              : null) as ImageProvider?)
                              : (vm.imageFile != null
                              ? FileImage(vm.imageFile!)
                              : (user.image.isNotEmpty
                              ? NetworkImage(user.image)
                              : null) as ImageProvider?),
                          backgroundColor: Colors.grey[200],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _pickImage(vm),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: user.firstName,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (v) => _firstName = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: user.lastName,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (v) => _lastName = v ?? '',
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    child: vm.loading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState!.save();
                          try {
                            await vm.updateProfile(
                              firstName: _firstName,
                              lastName: _lastName,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update profile: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
