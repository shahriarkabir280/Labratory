import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendServiceEditUserProfile {
  static const String baseUrl = "https://famnest.onrender.com"; // Replace with your FastAPI server URL

  // Register a User
  static Future<Map<String, dynamic>> editUserProfile(String new_name, String new_email,String old_email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/edit-profile/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "new_name": new_name,
        "new_email": new_email,
        "old_email": old_email
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Profile Update failed: ${response.body}");
    }
  }
}
