import 'package:cms/db/mongodb.dart';
import 'package:cms/marks/display.dart';
import 'package:flutter/material.dart';

class CheckLoginState extends StatefulWidget {
  const CheckLoginState({super.key});

  @override
  State<CheckLoginState> createState() => _CheckLoginStateState();
}

class _CheckLoginStateState extends State<CheckLoginState> {
  void initState() {
    super.initState();
    MongoDatabase.getState().then((token) {
      checkLogin(token);
    });
  }

  void checkLogin(String? token) async {
    // print("Token ${token}");
    if (token == "" || token == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (BuildContext context) {
          return Login();
        },
      ), (route) => false);
    } else {
      String auth_token = token;
      final userData = MongoDatabase.verifyToken(auth_token);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) {
                return DisplayMarks();
              },
              settings: RouteSettings(arguments: userData)),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var username = TextEditingController();
  var password = TextEditingController();
  bool isUsername = false; // To check if username field is empty
  bool isPass = false; // To check if password field is empty

  @override
  void initState() {
    super.initState();
    username.addListener(() {
      setState(() {
        isUsername = username.text.isNotEmpty;
      });
    });

    password.addListener(() {
      setState(() {
        isPass = password.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: username,
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: isUsername && isPass
                            ? () => _loginUser(username.text, password.text)
                            : null,
                        child: Text("Login")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginUser(String username, String password) async {
    var result = await MongoDatabase.login(username, password);
    ;
    if (result == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please try to login with correct credentials")));
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) {
                return DisplayMarks();
              },
              settings:
                  RouteSettings(arguments: MongoDatabase.verifyToken(result))),
          (route) => false);
    }
  }
}
