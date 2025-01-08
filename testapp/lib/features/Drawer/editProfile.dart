import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:testapp/authentications/validator.dart';
import 'package:testapp/Models/UserState.dart';
import 'package:testapp/backend_connections/FASTAPI.dart';
import 'dart:io';

final FASTAPI fastAPI = FASTAPI(); // Use the FASTAPI abstraction for backend calls

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  File? _image;

  // Controllers to manage form fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  // Function to pick an image (camera or gallery)
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Take a Picture"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text("Choose from Gallery"),
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
  void _updateUserInfo(UserState userState , String name , String email) {
    final updatedUser = User(
      name: name, // New name entered by the user
      email: email, // New email entered by the user
      password: userState.currentUser?.password ?? '', // Keep the old password (since we didn't update it)
      groups: userState.currentUser?.groups ?? [], // Keep the same groups (if they were not updated)
      loginStatus: userState.currentUser?.loginStatus ?? false, // Keep the same login status
      createdAt: userState.currentUser?.createdAt ?? '', // Keep the same created date
    );

    // Now update the UserState with the new User object
    userState.updateUser(updatedUser);
  }
  void _showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context, listen: true);
    // Accessing the email and name of the current user
    final old_email = userState.currentUser?.email ?? 'No Email';

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit My Profile'),
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
                      backgroundImage: _image == null
                          ? AssetImage('assets/user_image.png') // Placeholder
                          : FileImage(_image!) as ImageProvider,
                      backgroundColor: Colors.grey[300],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter new name',
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your name'
                    : null,
                onChanged: (value) => setState(() => _name = value),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter new email',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your email'
                    : null,
                onChanged: (value) => setState(() => _email = value),
              ),
              SizedBox(height: 60),
              Center(
                child: SizedBox(
                  width: 200, // Adjust the width as needed
                  child: ElevatedButton(
                    onPressed: () async {
                      final emailError = Validators.validateEmail(_emailController.text);
                      if (emailError != null) {
                        Validators.showSnackBar(context, emailError);
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        print("Name: $_name");
                        print("Email: $_email");
                        try {
                          await fastAPI.editUserProfile(
                            context,
                            _nameController.text,
                            _emailController.text,
                            old_email
                          );
                          _showSnackbar("Your Profile is Updated Successfully!!", Colors.green);
                          // Update the current user in UserState
                          _updateUserInfo(userState, _name, _email); // This updates the currentUser in UserState
                          // navigator
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
                        } catch (e) {
                          Validators.showSnackBar(context, "Error: $e");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent,     // Text color on the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Save Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Makes the text bold
                      ),
                    ),
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
