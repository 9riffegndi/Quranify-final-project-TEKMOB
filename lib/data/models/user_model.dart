class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String password;
  final DateTime dateJoined;
  DateTime? lastLogin;
  final String? socialProvider; // 'google', 'facebook', etc.

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.dateJoined,
    this.lastLogin,
    this.socialProvider,
  });

  // Create from JSON (or Map)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      dateJoined: DateTime.parse(json['dateJoined'] as String),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      socialProvider: json['socialProvider'] as String?,
    );
  }

  // Convert to JSON (or Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'password': password,
      'dateJoined': dateJoined.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'socialProvider': socialProvider,
    };
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? fullName,
    String? username,
    String? email,
    String? password,
    DateTime? lastLogin,
    String? socialProvider,
  }) {
    return UserModel(
      id: this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      dateJoined: this.dateJoined,
      lastLogin: lastLogin ?? this.lastLogin,
      socialProvider: socialProvider ?? this.socialProvider,
    );
  }
}
