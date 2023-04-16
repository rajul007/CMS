import 'package:cms/db/mongodb.dart';
import 'package:cms/users/login.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CheckLoginState(),
    );
  }
}
