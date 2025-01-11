import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:testapp/authentications/validator.dart';
import 'package:testapp/Models/UserState.dart';
import 'package:testapp/backend_connections/FASTAPI.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

final FASTAPI fastAPI = FASTAPI();

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _profilePictureUrl = '';
  File? _image; // For mobile
  Uint8List? _imageBytes; // For Flutter Web

  // Controllers to manage form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userState = Provider.of<UserState>(context, listen: false);
    _profilePictureUrl = userState.currentUser?.profilePictureUrl ?? 'No Profile Picture';
    _nameController.text = userState.currentUser?.name ?? '';
    _emailController.text = userState.currentUser?.email ?? '';
  }
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          // For web, use readAsBytes
          pickedFile.readAsBytes().then((bytes) {
            setState(() {
              _imageBytes = bytes;
            });
          });
        } else {
          // For mobile, use File
          _image = File(pickedFile.path);
        }
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a Picture"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_album),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile(UserState userState) async {
    final emailError = Validators.validateEmail(_emailController.text);
    if (emailError != null) {
      Validators.showSnackBar(context, emailError);
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        // Handle image upload for web and mobile
        if (_imageBytes != null || _image != null) {
          Uint8List imageData;
          if (_imageBytes != null) {
            // Use _imageBytes for web
            imageData = _imageBytes!;
          } else {
            // Convert File to Uint8List for mobile
            imageData = await _image!.readAsBytes();
          }
          var result = await fastAPI.updateProfilePicture(context, imageData);
          setState(() {
            _profilePictureUrl = result["profile_picture_url"];
            _imageBytes = null;
            _image = null;
          });
        }

        // Update profile details
        await fastAPI.editUserProfile(
          context,
          _nameController.text,
          _emailController.text,
          userState.currentUser?.email ?? '',
          _profilePictureUrl,
        );
        _updateUserInfo(userState);
        _showSnackbar("Your Profile is Updated Successfully!", Colors.green);

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } catch (e) {
        Validators.showSnackBar(context, "Error: $e");
      }
    }
  }

  void _updateUserInfo(UserState userState) {
    final updatedUser = User(
      name: _nameController.text,
      email: _emailController.text,
      groups: userState.currentUser?.groups ?? [],
      loginStatus: userState.currentUser?.loginStatus ?? false,
      createdAt: userState.currentUser?.createdAt ?? '',
      profilePictureUrl: _profilePictureUrl,
    );
    userState.updateUser(updatedUser);
  }

  void _showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit My Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageBytes != null
                          ? MemoryImage(_imageBytes!)
                          : _image != null
                          ? FileImage(_image!)
                          : (_profilePictureUrl.isNotEmpty
                          ? NetworkImage(_profilePictureUrl)
                          : const AssetImage('assets/default_profile_picture.png')) as ImageProvider,
                      backgroundColor: Colors.grey[300],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon: Icon(Icons.person, color: Colors.teal),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon: Icon(Icons.email, color: Colors.teal),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter your email' : null,
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _saveProfile(userState),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
