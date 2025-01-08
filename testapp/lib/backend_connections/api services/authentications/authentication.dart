import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = "https://famnest.onrender.com"; // Replace with your FastAPI server URL

  // Register a User
  static Future<Map<String, dynamic>> registerUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Registration failed: ${response.body}");
    }
  }

  // Login a User
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  // Logout a User
  static Future<Map<String, dynamic>> logoutUser(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/logout/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Logout failed: ${response.body}");
    }
  }

  static Future<Map<String, dynamic>> createGroup(String email, String groupName, String groupCode) async {
    final response = await http.post(
      Uri.parse("$baseUrl/create-group/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "group_name": groupName,
        "group_code": groupCode,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        print('SUCCCESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS');
        return jsonResponse;
      } else {
        throw Exception("Failed: ${jsonResponse['message']}");
      }
    } else {
      throw Exception("Group creation failed: ${response.body}");
    }
  }

  // Find a Group
  static Future<Map<String, dynamic>> findGroup(String groupCode) async {
    final response = await http.post(
      Uri.parse("$baseUrl/find-group/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"group_code": groupCode}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Group not found: ${response.body}");
    }
  }

  // Get User Data
// Get User Data
  static Future<Map<String, dynamic>> getUserData(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/get-user-data/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Convert groups if present
      if (data['groups'] != null) {
        data['groups'] = (data['groups'] as List<dynamic>)
            .map((group) => {
          "group_name": group["group_name"] ?? "Unknown",
          "group_code": group["group_code"] ?? "",
          "created_at": group["created_at"] ?? null,
        })
            .toList();
      }
      return data;
    } else {
      throw Exception("Failed to fetch user data: ${response.body}");
    }
  }



  // Forgot Password: Send Reset Code
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/forgot-password/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Password reset request failed: ${response.body}");
    }
  }


  // Reset Password
  static Future<Map<String, dynamic>> resetPassword(
      String email,
      String resetCode,
      String newPassword,
      ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/reset-password/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "reset_code": resetCode,
        "new_password": newPassword,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Password reset failed: ${response.body}");
    }
  }


  // Get All Users
  static Future<List<dynamic>> getAllUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/all-users/"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch all users: ${response.body}");
    }
  }
}
