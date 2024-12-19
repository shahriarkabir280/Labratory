import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// for geting name
Future<String> get_name(BuildContext context, String email) async {
  final String url = 'https://famnest.onrender.com/get-name/'; // global url diye connect hocchi

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({"email": email}),
  );

  //if (response.statusCode == 200) {
  final responseData = json.decode(response.body);
  // returning the boolean from fastapi
  return responseData["message"];
  //} else {
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(content: Text('Failed to save data')),
  // );
  return "";
  //}
}