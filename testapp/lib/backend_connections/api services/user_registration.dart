import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// for registration
Future<void> user_registration(
    BuildContext context,String name, String email, String pass) async {
  final String url = 'https://famnest.onrender.com/save-input/'; // global url diye connect hocchi

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({"name": name, "email": email, "password":pass , "joinCreate": false}),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);

    // Showing message from the response to the signup page
    if(responseData['message']=="Successfully Registered")
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message']),backgroundColor: Colors.lightGreen),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message']),backgroundColor: Colors.redAccent),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save data')),
    );
  }
}