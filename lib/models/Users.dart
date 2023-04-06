import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

UserSchema userSchemaFromJson(String str) =>
    UserSchema.fromJson(json.decode(str));

String userSchemaToJson(UserSchema data) => json.encode(data.toJson());

class UserSchema {
  UserSchema({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.date,
    required this.username,
    required this.address,
    required this.userType,
    required this.phonenumber,
  });

  ObjectId id;
  String name;
  String email;
  String password;
  DateTime date;
  String username;
  String address;
  String userType;
  String phonenumber;

  factory UserSchema.fromJson(Map<String, dynamic> json) => UserSchema(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        date: json["date"],
        username: json["username"],
        address: json["address"],
        userType: json["userType"],
        phonenumber: json["phonenumber"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "date": date,
        "username": username,
        "address": address,
        "userType": userType,
        "phonenumber": phonenumber,
      };
}
