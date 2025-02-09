import 'package:flutter/material.dart';
import 'package:testapp/backend_connections/api services/authentications/authentication.dart';
import 'package:testapp/backend_connections/api%20services/features/TimeCapsuleBackend.dart';

import 'dart:typed_data';


class FASTAPI {

  // For user registration
  Future<Map<String, dynamic>> registerUser(
      BuildContext context, String name, String email, String password, String profile_picture_url) async {
    return await BackendService.registerUser(name, email, password, profile_picture_url);
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
  // Join Group
  Future<Map<String, dynamic>> joinGroup(
      BuildContext context, String email, String groupCode) async {
    return await BackendService.joinGroup(email, groupCode);
  }

  // Leave Group
  Future<Map<String, dynamic>> leaveGroup(
      BuildContext context, String email, String groupCode) async {
    return await BackendService.leaveGroup(email, groupCode);
  }

  // Update Current Group
  Future<Map<String, dynamic>> updateCurrentGroup(
      BuildContext context, String email, String groupCode) async {
    return await BackendService.updateCurrentGroup(email, groupCode);
  }

  // For finding a group
  Future<Map<String, dynamic>> findGroup(
      BuildContext context, String groupCode) async {
    return await BackendService.findGroup(groupCode);
  }

  // Get Group Members
  Future<Map<String, dynamic>> getGroupMembers(
      BuildContext context, String groupCode) async {
    return await BackendService.getGroupMembers(groupCode);
  }

  Future<Map<String, dynamic>> removeGroupMember(
      BuildContext context, String groupCode, String email) async {
    return await BackendService.removeGroupMember(groupCode, email);
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
      BuildContext context, String new_name, String new_email , String old_email, String profile_picture_url) async {
    return await BackendService.editUserProfile(new_name, new_email, old_email,profile_picture_url);
  }
  // For Uploading Profile Picture
  Future<Map<String, dynamic>> updateProfilePicture(
      BuildContext context, Uint8List imageBytes) async {
    return await BackendService.uploadProfilePicture(imageBytes);
  }

  // Change Password
  Future<Map<String, dynamic>> ChangeUserPassword(
      BuildContext context, String email, String new_password) async {
    return await BackendService.ChangeUserPassword(email, new_password);
  }
  // Upload Time Capsule Media Files
  Future<Map<String, dynamic>> UploadMediaFilesToCloudinary(
      BuildContext context,File file,String file_name,String group_code,String file_type) async {
      return await BackendServicesForTimeCapsule.uploadMediaFilesToCloudinary(file,file_name, group_code,file_type);
  }
  //  Fetching Time Capsule Images
  Future<List<Map<String, dynamic>>> FetchMediaFiles(
      BuildContext context, String group_code, String media_type) async {
    return await BackendServicesForTimeCapsule.fetchMediaFiles(group_code, media_type);
  }
  // Deleting an item from mongodb atlas
  Future<void> DeleteItems(BuildContext context, String group_code, int index , String media_type) async {
    await BackendServicesForTimeCapsule.DeleteItem(group_code, index, media_type);
  }

  // Rename an item from mongodb atlas
  Future<void> RenameItems(BuildContext context, String group_code, int index, String new_name, String media_type) async {
    await BackendServicesForTimeCapsule.RenameItem(group_code, index, new_name, media_type);
  }

  // Upload Stories
  Future<void> UploadStories(
      BuildContext context,String title,String content,String group_code) async {
      await BackendServicesForTimeCapsule.uploadStories(title, content, group_code);
  }

  // Update Story from mongodb atlas
  Future<void> UpdateStory(BuildContext context, String group_code, int index, String title , String content) async {
    await BackendServicesForTimeCapsule.updateStory(group_code, index, title, content);
  }

  // delete Story from mongodb atlas
  Future<void> DeleteStory(BuildContext context, String group_code, int index) async {
    await BackendServicesForTimeCapsule.deleteStory(group_code, index);
  }
// // Upload Time Capsule Image
//   Future<Map<String, dynamic>> UploadVideoToCloudinary(
//       BuildContext context,File videoFile,String file_name,String group_code) async {
//     return await BackendServicesForTimeCapsule.uploadVideoToCloudinary(videoFile,file_name, group_code);
//   }

}
