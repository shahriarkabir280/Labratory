import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _birthDate = '';
  File? _image;

  // Controllers to manage form fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();

  // List to store dynamic fields and their controllers
  List<Map<String, dynamic>> _additionalFields = [];

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

  Future<void> _selectBirthDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _birthDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        _birthDateController.text = _birthDate;
      });
    }
  }

  void _showAddMoreOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add More Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.phone),
                title: Text("Phone"),
                onTap: () {
                  Navigator.pop(context);
                  _addAdditionalField("Phone");
                },
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Address"),
                onTap: () {
                  Navigator.pop(context);
                  _addAdditionalField("Address");
                },
              ),
              ListTile(
                leading: Icon(Icons.note),
                title: Text("Others"),
                onTap: () {
                  Navigator.pop(context);
                  _addAdditionalField("Others");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addAdditionalField(String fieldName) {
    setState(() {
      _additionalFields.add({
        "field": fieldName,
        "controller": TextEditingController(),
      });
    });
  }

  void _deleteAdditionalField(int index) {
    setState(() {
      _additionalFields[index]["controller"].dispose();
      _additionalFields.removeAt(index);
    });
  }

  @override
  void dispose() {
    // Dispose of all controllers to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    for (var field in _additionalFields) {
      field["controller"].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) => setState(() => _name = value),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => setState(() => _email = value),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _birthDateController,
                decoration: InputDecoration(
                  hintText: 'Pick your birth date',
                  labelText: 'Birth Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectBirthDate,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _showAddMoreOptionsDialog,
                child: Text('Add More Options', style: TextStyle(color: Colors.blue, fontSize: 16)),
              ),
              SizedBox(height: 20),
              for (int i = 0; i < _additionalFields.length; i++) ...[
                Row(
                  children: [
                    Icon(
                      _additionalFields[i]["field"] == "Phone"
                          ? Icons.phone
                          : _additionalFields[i]["field"] == "Address"
                          ? Icons.home
                          : Icons.note,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _additionalFields[i]["controller"],
                        decoration: InputDecoration(
                          hintText: 'Enter your ${_additionalFields[i]["field"]}',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => _deleteAdditionalField(i),
                    ),
                  ],
                ),
                Divider(),
              ],
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Name: $_name");
                    print("Email: $_email");
                    print("Birth Date: $_birthDate");
                    for (var field in _additionalFields) {
                      print("${field['field']}: ${field['controller'].text}");
                    }
                  }
                },
                child: Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
