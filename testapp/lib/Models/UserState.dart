import 'package:flutter/material.dart';

/// Group Model
class Group {
  final String groupName;
  final String groupCode;
  final String? createdAt;

  Group({
    required this.groupName,
    required this.groupCode,
    this.createdAt,
  });

  // Factory method to create a Group from JSON
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupName: json['group_name'] ?? 'Unknown',
      groupCode: json['group_code'] ?? '',
      createdAt: json['created_at'],
    );
  }

  // Convert Group to JSON
  Map<String, dynamic> toJson() {
    return {
      "group_name": groupName,
      "group_code": groupCode,
      "created_at": createdAt,
    };
  }
}

/// User Model
class User {
  final String name;
  final String email;
  //final String password;
  final List<Group> groups;
  Group? currentGroup;
  final bool loginStatus;
  final String createdAt;
  final String? profilePictureUrl; // Add profilePictureUrl field

  User({
    required this.name,
    required this.email,
   // required this.password,
    required this.groups,
    this.currentGroup,
    required this.loginStatus,
    required this.createdAt,
    this.profilePictureUrl, // Initialize profilePictureUrl as optional
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
     // password: json['password'],
      groups: (json['groups'] as List<dynamic>)
          .map((groupJson) => Group.fromJson(groupJson))
          .toList(),
      currentGroup: json['current_group'] != null
          ? Group.fromJson(json['current_group'])
          : null,
      loginStatus: json['login_status'] ?? false,
      createdAt: json['created_at'],
      profilePictureUrl: json['profile_picture_url'], // Parse profilePictureUrl
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      //"password": password,
      "groups": groups.map((group) => group.toJson()).toList(),
      "current_group": currentGroup?.toJson(),
      "login_status": loginStatus,
      "created_at": createdAt,
      "profile_picture_url": profilePictureUrl, // Include profilePictureUrl
    };
  }
}

/// UserState Class
class UserState with ChangeNotifier {
  User? _currentUser;

  // Getter for the current user
  User? get currentUser => _currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  // Login method to set the current user
  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Logout method to clear the current user
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Update method to refresh the user state
  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Update the current group
  void updateCurrentGroup(Group newGroup) {
    if (_currentUser != null) {
      _currentUser = User(
        name: _currentUser!.name,
        email: _currentUser!.email,
        //password: _currentUser!.password,
        groups: _currentUser!.groups,
        currentGroup: newGroup,
        loginStatus: _currentUser!.loginStatus,
        createdAt: _currentUser!.createdAt,
        profilePictureUrl: _currentUser!.profilePictureUrl,
      );
      notifyListeners();
    }
  }

  // Update the profile picture
  void updateProfilePicture(String newProfilePictureUrl) {
    if (_currentUser != null) {
      _currentUser = User(
        name: _currentUser!.name,
        email: _currentUser!.email,
        //password: _currentUser!.password,
        groups: _currentUser!.groups,
        currentGroup: _currentUser!.currentGroup,
        loginStatus: _currentUser!.loginStatus,
        createdAt: _currentUser!.createdAt,
        profilePictureUrl: newProfilePictureUrl, // Update the profile picture URL
      );
      notifyListeners();
    }
  }

  // Add a new group to the user's groups
  void addGroup(Group group) {
    if (_currentUser != null) {
      _currentUser!.groups.add(group);
      notifyListeners();
    }
  }

  // Set the current group for the user
  void setCurrentGroup(Group group) {
    if (_currentUser != null) {
      _currentUser!.currentGroup = group;
      notifyListeners();
    }
  }
}
