import 'package:flutter/material.dart';

class Group {
  final String groupName;
  final String groupCode;
  final String? createdAt; // Nullable to handle cases where created_at is missing

  Group({
    required this.groupName,
    required this.groupCode,
    this.createdAt, // Optional field
  });

  // Factory method to create a Group from JSON
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupName: json['group_name'] ?? 'Unknown', // Default to 'Unknown' if missing
      groupCode: json['group_code'] ?? '', // Default to empty string if missing
      createdAt: json['created_at'], // Optional, can be null
    );
  }
}

class User {
  final String name;
  final String email;
  final String password;
  final List<Group> groups;
  final bool loginStatus;
  final String createdAt;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.groups,
    required this.loginStatus,
    required this.createdAt,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      groups: (json['groups'] as List<dynamic>)
          .map((groupJson) => Group.fromJson(groupJson))
          .toList(),
      loginStatus: json['login_status'] ?? false, // Default to false if missing
      createdAt: json['created_at'],
    );
  }
}

class UserState with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    print("Updated User Groups: ${user.groups}");
    notifyListeners();
  }
}
