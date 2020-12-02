// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> user) => json.encode(List<dynamic>.from(user.map((x) => x.toJson())));

class User {
  String username;
  String email;
  bool isCompany;
  String phone;

  User({
    this.username,
    this.email,
    this.isCompany,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json["username"],
    email: json["email"],
    isCompany: json["isCompany"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "isCompany": isCompany,
    "phone": phone,
  };
}