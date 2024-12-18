import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// all groups record
Future<void> all_groups_info(
    BuildContext context,String g_name, String g_pass) async {
  final String url = 'https://famnest.onrender.com/all-groups-record/'; // default android emu url diye connect hocchi
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({"name": g_name, "password":g_pass}),
  );

  if (response.statusCode == 200) {

  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save data')),
    );
  }
}