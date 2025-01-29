import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart'; // For determining MIME type dynamically
import 'package:http_parser/http_parser.dart' as http_parser; // Import for MediaType

class BackendServicesForTimeCapsule {

  static const String baseUrl = "https://famnest.onrender.com"; // Replace with your FastAPI server URL

  // // Upload Profile Picture
  // static Future<Map<String, dynamic>> uploadProfilePicture(
  //     Uint8List imageBytes) async {
  //   try {
  //     final uri = Uri.parse("$baseUrl/upload-profile-picture/");
  //
  //     // Determine MIME type dynamically
  //     final mimeType = lookupMimeType('', headerBytes: imageBytes) ?? 'application/octet-stream';
  //     final extension = mimeType.split('/').last; // Get the file extension (e.g., 'png', 'jpg')
  //
  //     // Create a multipart request
  //     final request = http.MultipartRequest('POST', uri)
  //       ..files.add(http.MultipartFile.fromBytes(
  //         'file', // The field name FastAPI expects
  //         imageBytes,
  //         filename: 'profile_picture.$extension', // Use dynamic extension
  //         contentType: http_parser.MediaType('image', extension), // MIME as a String
  //       ));
  //
  //     // Send the request
  //     final response = await request.send();
  //     if (response.statusCode == 200) {
  //       final responseBody = await response.stream.bytesToString();
  //       return jsonDecode(responseBody);
  //     } else {
  //       final errorBody = await response.stream.bytesToString();
  //       throw Exception("Profile Picture Upload failed: $errorBody");
  //     }
  //   } catch (e) {
  //     throw Exception("Error connecting to server: $e");
  //   }
  // }
  // Upload Time Capsule Images to Cloudinary
   static Future<Map<String, dynamic>> uploadMediaFilesToCloudinary(
      File mediaFile, String fileName, String groupCode, String file_type) async {
    // try {
      final uri = Uri.parse("$baseUrl/upload-mediafiles/");
      final request = http.MultipartRequest('POST', uri)
        ..fields['file_name'] = fileName // Add file name
        ..fields['group_code'] = groupCode // Add group code
        ..fields['resource_type'] = file_type // Add file type
        ..files.add(await http.MultipartFile.fromPath(
          'file', // Field name expected by the server
          mediaFile.path,
        ));
      final response = await request.send();
      print("File uploaded successfully!");

      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      print("Response: $jsonResponse");
      return {
        'file_name': fileName,
        'url': jsonResponse['url'],
      };
  }
  // Fetching Images from db
  // static Future<List<Map<String, dynamic>>> fetchImages(String group_code) async {
  //   final uri = Uri.parse("$baseUrl/get-images/").replace(queryParameters: {
  //     'group_code': group_code,
  //   });
  //   final response = await http.get(uri);
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return List<Map<String, dynamic>>.from(data['images']);
  //   } else {
  //     // Handle error: you can throw an exception or return an empty list
  //     print("Failed to fetch images. Status code: ${response.statusCode}");
  //     return []; // Return an empty list on error
  //   }
  // }
  static Future<List<Map<String, dynamic>>> fetchMediaFiles(String group_code, String media_type) async {
    final uri = Uri.parse("$baseUrl/get-mediafiles/").replace(queryParameters: {
      'group_code': group_code,
      'media_type': media_type
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['${media_type}s']);
    } else {
      // Handle error: you can throw an exception or return an empty list
      print("Failed to fetch media files. Status code: ${response.statusCode}");
      return []; // Return an empty list on error
    }
  }

  // Deleting items from mongodb database
  static Future<void> DeleteItem(String group_code, int index, String media_type) async {
    final url = Uri.parse("$baseUrl/delete-mediafiles/$group_code/$index/$media_type");
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print("File Deleted Successfully");
      } else {
        // Handle API error
        print("Failed to delete item: ${response.body}");
        throw Exception("Failed to delete file");
      }
    } catch (error) {
      // Handle network or unexpected errors
      print("Error occurred while deleting file: $error");
      rethrow;
    }
  }

  // Renaming items from mongodb database
  static Future<void> RenameItem(String group_code, int index, String new_name, String media_type) async {
    final url = Uri.parse("$baseUrl/rename-mediafiles/$group_code/$index/$new_name/$media_type");
    try {
      final response = await http.put(url);

      if (response.statusCode == 200) {
        print("Item Renamed Successfully");
      } else {
        // Handle API error
        throw Exception("Failed to rename file");
      }
    } catch (error) {
      // Handle network or unexpected errors
      print("Error occurred while renaming file: $error");
      rethrow;
    }
  }

  // static Future<Map<String, dynamic>> uploadFilesToCloudinary(
  //     File mediaFile, String fileName, String groupCode, String file_type) async {
  //   // try {
  //   final uri = Uri.parse("$baseUrl/upload-mediafiles/");
  //   final request = http.MultipartRequest('POST', uri)
  //     ..fields['file_name'] = fileName // Add file name
  //     ..fields['group_code'] = groupCode // Add group code
  //     ..fields['resource_type'] = file_type // Add file type
  //     ..files.add(await http.MultipartFile.fromPath(
  //       'file', // Field name expected by the server
  //       mediaFile.path,
  //     ));
  //   final response = await request.send();
  //   print("File uploaded successfully!");
  //
  //   final responseBody = await response.stream.bytesToString();
  //   final jsonResponse = json.decode(responseBody);
  //   print("Response: $jsonResponse");
  //   return {
  //     'file_name': fileName,
  //     'url': jsonResponse['url'],
  //   };
  // }

  // uploading stories from mongodb database
  static Future<void> uploadStories(String title, String content, String groupCode) async {
    final url = Uri.parse("$baseUrl/upload-story/");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "group_code": groupCode,
          "title": title,
          "content": content,
        }),
      );
      if (response.statusCode == 200) {
        print("Story Added Successfully");
      } else {
        throw Exception("Failed to add story: ${response.body}");
      }
    } catch (error) {
      print("Error occurred while uploading story: $error");
      rethrow;
    }
  }


  //Updating Stories
  static Future<void> updateStory(String group_code, int index, String title, String content) async {
    final url = Uri.parse("$baseUrl/update-story/$group_code/$index/$title/$content");
    try {
      final response = await http.put(url);

      if (response.statusCode == 200) {
        print("Story Edited Successfully");
      } else {
        // Handle API error
        throw Exception("Failed to edit story");
      }
    } catch (error) {
      // Handle network or unexpected errors
      print("Error occurred while editing file: $error");
      rethrow;
    }
  }
  //Delete Stories
  static Future<void> deleteStory(String group_code, int index) async {
    final url = Uri.parse("$baseUrl/delete-story/$group_code/$index");
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print("Story Deleted Successfully");
      } else {
        // Handle API error
        throw Exception("Failed to delete story");
      }
    } catch (error) {
      // Handle network or unexpected errors
      print("Error occurred while deleting file: $error");
      rethrow;
    }
  }
}

