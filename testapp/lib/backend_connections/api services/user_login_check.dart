import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// for login
Future<bool> user_login_check(BuildContext context, String email, String pass) async {
  final String url = 'https://famnest.onrender.com/check-input/'; // default android emu url diye connect hocchi

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({"email": email , "password": pass}),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);

    // Show message from the response to the login page
    if(responseData['message']=="Login Successful")
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message']),backgroundColor: Colors.lightGreen),

      );
      return true;}
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message']),backgroundColor: Colors.redAccent),
      );
      return false;
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save data')),
    );
    return false;
  }
}