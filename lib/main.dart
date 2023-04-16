import 'package:cms/db/mongodb.dart';
import 'package:cms/users/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        appBarTheme: AppBarTheme(
          // iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromARGB(190, 0, 0, 0),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(255, 54, 54, 54)),
        ),
      ),
      home: CheckLoginState(),
    );
  }
}
