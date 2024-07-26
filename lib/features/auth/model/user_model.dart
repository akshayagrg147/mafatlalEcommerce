import 'dart:convert';

class User {
  final String email;
  final String fullName;
  final int userType;
  final String state;
  final String district;
  final DateTime createdOn;
  final String createdBy;
  final DateTime updatedOn;
  final String updatedBy;

  User({
    required this.email,
    required this.fullName,
    required this.userType,
    required this.state,
    required this.district,
    required this.createdOn,
    required this.createdBy,
    required this.updatedOn,
    required this.updatedBy,
  });

  factory User.fromJsonString(String data) {
    return User.fromJson(jsonDecode(data));
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      fullName: json['full_name'],
      userType: json['user_type'],
      state: json['state'],
      district: json['district'],
      createdOn: DateTime.parse(json['created_on']),
      createdBy: json['created_by'],
      updatedOn: DateTime.parse(json['updated_on']),
      updatedBy: json['updated_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'full_name': fullName,
      'user_type': userType,
      'state': state,
      'district': district,
      'created_on': createdOn.toIso8601String(),
      'created_by': createdBy,
      'updated_on': updatedOn.toIso8601String(),
      'updated_by': updatedBy,
    };
  }

  String get getUserDataString => jsonEncode(toJson());
}
