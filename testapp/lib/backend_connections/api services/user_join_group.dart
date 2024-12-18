import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// for joining group
Future<String> finding_group(BuildContext context, String groupCode) async {
  final String url = 'https://famnest.onrender.com/check-group-password/'; // global url diye connect hocchi

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({"g_password": groupCode}),
  );

  //if (response.statusCode == 200) {
  final responseData = json.decode(response.body);
  // returning the boolean from fastapi
  return responseData['message'];
  //} else {
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(content: Text('Failed to save data')),
  // );
  return "";
  //}
}