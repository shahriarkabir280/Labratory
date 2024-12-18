import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> user_group_create(
    BuildContext context,String email, String newgroup , String groupcode) async {
  final String url = 'https://famnest.onrender.com/group-create/'; // global url diye connect hocchi

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({"email": email, "new_group":newgroup , "group_code":groupcode}),
  );

  if (response.statusCode != 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save data')),
    );
  }
}