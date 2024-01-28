import 'package:cms/marks/display.dart';
import 'package:cms/users/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider extends ChangeNotifier {
  String? _userType, _username, _name;

  String? get userType => _userType;
  String? get username => _username;
  String? get name => _name;

  void updateUserType(String? userType) {
    _userType = userType;
    notifyListeners();
  }

  void updateUsername(String? username) {
    _username = username;
    notifyListeners();
  }

  void updateName(String? name) {
    _name = name;
    notifyListeners();
  }

  void setUserDetails(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    updateName(decodedToken['user']['name']);
    updateUserType(decodedToken['user']['userType']);
    updateUsername(decodedToken['user']['username']);
  }

  Future<void> loginUser(
      BuildContext context, String username, String password) async {
    // final host = 'your_host'; // Replace with your API host
    final url = Uri.parse('http://192.168.19.239:5000/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final Map<String, dynamic> json = jsonDecode(response.body);

      if (json['success']) {
        // Save the auth-token and handle navigation
        const storage = FlutterSecureStorage();
        await storage.write(key: "token", value: json['authtoken']);

        setUserDetails(json['authtoken']);

        // Navigate
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return const DisplayMarks();
                },
                settings: RouteSettings(arguments: json['authtoken'])),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${json['error']}")));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Internal Server Error: $error')));
    }
    notifyListeners();
  }

  void logoutUser(BuildContext context) async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    // updateName(null);
    // updateUserType(null);
    // updateUsername(null);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (BuildContext context) {
        return const Login();
      },
    ), (route) => false);
    notifyListeners();
  }
}
