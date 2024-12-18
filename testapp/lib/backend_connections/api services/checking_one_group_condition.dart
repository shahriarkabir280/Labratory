import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// for checking at least one group criteria
Future<bool> checking_one_group_condition(BuildContext context, String email) async {
  final String url = 'https://famnest.onrender.com/check-one-group-criteria/'; // default android emu url diye connect hocchi

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({"email": email}),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    // return the boolean from fastapi
    return responseData["exists"];
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save data')),
    );
    return false;
  }
}