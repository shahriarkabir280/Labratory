

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart'; // For determining MIME type dynamically
import 'package:http_parser/http_parser.dart' as http_parser; // Import for MediaType

class BackendService {
  static const String baseUrl = "https://famnest.onrender.com"; // Replace with your FastAPI server URL

  // Register a User
  static Future<Map<String, dynamic>> registerUser(String name, String email, String password, String profile_picture_url) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "profile_picture_url": profile_picture_url
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

  // Join Group
  static Future<Map<String, dynamic>> joinGroup(String email, String groupCode) async {
    final response = await http.post(
      Uri.parse("$baseUrl/join-group/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "group_code": groupCode}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to join group: ${response.body}");
    }
  }


  // Update Current Group
  static Future<Map<String, dynamic>> updateCurrentGroup(String email, String groupCode) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update-current-group/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "group_code": groupCode}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update current group: ${response.body}");
    }
  }

  // Leave Group
  static Future<Map<String, dynamic>> leaveGroup(String email, String groupCode) async {
    final response = await http.post(
      Uri.parse("$baseUrl/leave-group/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "group_code": groupCode}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to leave group: ${response.body}");
    }
  }

  // Get Group Members
  static Future<Map<String, dynamic>> getGroupMembers(String groupCode) async {
    final response = await http.post(
      Uri.parse("$baseUrl/get-group-members/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"group_code": groupCode}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get group members: ${response.body}");
    }
  }

  static Future<Map<String, dynamic>> removeGroupMember(
      String groupCode, String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/remove-group-member/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "group_code": groupCode,
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to remove group member: ${response.body}");
    }
  }


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

  //edit user profile

  static Future<Map<String, dynamic>> editUserProfile(
      String newName,
      String newEmail,
      String oldEmail,
      String profilePictureUrl,
      ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/edit-profile/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "new_name": newName,
          "new_email": newEmail,
          "old_email": oldEmail,
          "profile_picture_url": profilePictureUrl,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Decode the error message for better debugging
        final error = jsonDecode(response.body);
        throw Exception("Profile Update failed: ${error['detail'] ?? 'Unknown error'}");
      }
    } catch (e) {
      // Log or rethrow the error for debugging
      print("Error in editUserProfile: $e");
      throw Exception("An error occurred while updating the profile: $e");
    }
  }



  // Upload Profile Picture
  static Future<Map<String, dynamic>> uploadProfilePicture(
      Uint8List imageBytes) async {
    try {
      final uri = Uri.parse("$baseUrl/upload-profile-picture/");

      // Determine MIME type dynamically
      final mimeType = lookupMimeType('', headerBytes: imageBytes) ?? 'application/octet-stream';
      final extension = mimeType.split('/').last; // Get the file extension (e.g., 'png', 'jpg')

      // Create a multipart request
      final request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes(
          'file', // The field name FastAPI expects
          imageBytes,
          filename: 'profile_picture.$extension', // Use dynamic extension
          contentType: http_parser.MediaType('image', extension), // MIME as a String
        ));

      // Send the request
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        final errorBody = await response.stream.bytesToString();
        throw Exception("Profile Picture Upload failed: $errorBody");
      }
    } catch (e) {
      throw Exception("Error connecting to server: $e");
    }
  }

  // Change User Password
  static Future<Map<String, dynamic>> ChangeUserPassword(String email, String new_password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/change-password/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "new_password": new_password
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Password Change failed: ${response.body}");
    }
  }


}

