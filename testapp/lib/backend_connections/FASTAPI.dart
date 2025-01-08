import 'package:flutter/material.dart';
import 'package:testapp/backend_connections/api services/authentications/authentication.dart';

class FASTAPI {
  // For user registration
  Future<Map<String, dynamic>> registerUser(
      BuildContext context, String name, String email, String password) async {
    return await BackendService.registerUser(name, email, password);
  }

  // For user login
  Future<Map<String, dynamic>> loginUser(
      BuildContext context, String email, String password) async {
    return await BackendService.loginUser(email, password);
  }

  // For user logout
  Future<Map<String, dynamic>> logoutUser(
      BuildContext context, String email) async {
    return await BackendService.logoutUser(email);
  }

  // For creating a group
  Future<Map<String, dynamic>> createGroup(BuildContext context, String email,
      String groupName, String groupCode) async {
    return await BackendService.createGroup(email, groupName, groupCode);
  }

  // For finding a group
  Future<Map<String, dynamic>> findGroup(
      BuildContext context, String groupCode) async {
    return await BackendService.findGroup(groupCode);
  }

  // For fetching user data
  Future<Map<String, dynamic>> getUserData(BuildContext context, String email) async {
    return await BackendService.getUserData(email);
  }


// Forgot Password: Send Reset Code
  Future<Map<String, dynamic>> sendResetCode(
      BuildContext context, String email) async {
    return await BackendService.forgotPassword(email);
  }


  // Reset Password
  Future<Map<String, dynamic>> resetPassword(
      BuildContext context,
      String email,
      String resetCode,
      String newPassword,
      ) async {
    return await BackendService.resetPassword(email, resetCode, newPassword);
  }

  // For fetching all users
  Future<List<dynamic>> getAllUsers(BuildContext context) async {
    return await BackendService.getAllUsers();
  }

   // For editing profile
  Future<Map<String, dynamic>> editUserProfile(
      BuildContext context, String new_name, String new_email , String old_email) async {
    return await BackendServiceEditUserProfile.editUserProfile(new_name, new_email, old_email);
  }
}
