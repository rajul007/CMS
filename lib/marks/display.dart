import 'dart:math';
import 'package:cms/db/mongodb.dart';
import 'package:cms/users/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mongo_dart/mongo_dart.dart' as md;

class DisplayMarks extends StatefulWidget {
  const DisplayMarks({super.key});

  @override
  State<DisplayMarks> createState() => _DisplayMarksState();
}

class _DisplayMarksState extends State<DisplayMarks> {
  var courseCode = TextEditingController();
  Map<String, dynamic> studentMarks = {
    "ct1": 0,
    "ct2": 0,
    "ca": 0,
    "dha": 0,
    "aa": 0,
    "attendance": 0,
    "grade": ""
  };
  bool isVisible = false;

  bool isValid = false;
  @override
  void initState() {
    super.initState();
    courseCode.addListener(() {
      setState(() {
        isValid = courseCode.text.length == 6;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: drawerDetails(user),
      appBar: AppBar(
        centerTitle: true,
        // title: Text("CMS"),
        title: Container(
          margin: EdgeInsets.only(
              right: MediaQuery.of(context).size.width / 2 - 150),
          // color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school),
              SizedBox(
                width: 5,
              ),
              Text("CMS"),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: courseCode,
                      decoration: InputDecoration(
                        labelText: "Course Code",
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(30)),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      onPressed: isValid
                          ? () => _getSubject(
                              md.ObjectId.fromHexString(user["user"]),
                              courseCode.text.toUpperCase())
                          : null,
                      child: Text("Submit"))
                ],
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(15),
                child: displayMarksTable(studentMarks),
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget drawerDetails(Map<String, dynamic> user) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context, user),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, Map<String, dynamic> user) =>
      Container(
        color: Color.fromARGB(190, 0, 0, 0),
        padding: EdgeInsets.only(
            top: 20 + MediaQuery.of(context).padding.top, bottom: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Text(
                "${user["name"][0].toUpperCase()}",
                style: TextStyle(fontSize: 40, color: Colors.black54),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${user["name"]}",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${user["username"]}",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${user["userType"]}"[0].toUpperCase() +
                  "${user["userType"]}".substring(1),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout", style: TextStyle(fontSize: 15)),
            onTap: () async {
              final storage = new FlutterSecureStorage();
              await storage.deleteAll();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (BuildContext context) {
                  return const Login();
                },
              ), (route) => false);
            },
          )
        ],
      );

  Future<void> _getSubject(md.ObjectId user, String courseCode) async {
    var result = await MongoDatabase.getSubject(courseCode);
    print(result);

    if (result == 0) {
      setState(() => isVisible = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Course Not Found..!! Please Enter correct Course Code.")));
    } else {
      var marks = await MongoDatabase.getMarks(user, result["id"]);
      if (marks == 0) {
        setState(() => isVisible = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You are not enrolled in this course..!!")));
      } else {
        studentMarks = marks;
        setState(() => isVisible = isVisible == false ? true : true);
        print(studentMarks);
      }
    }
  }

  Widget displayMarksTable(var studentMarks) {
    return studentMarks == null
        ? Text("No Records to display")
        : Visibility(
            visible: isVisible,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    "Components",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Marks",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(
                    Text(
                      "CT1",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['ct1'].toString(),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(
                    Text(
                      "CT2",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['ct2'].toString(),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(
                    Text(
                      "DHA",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['dha'].toString(),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(
                    Text(
                      "CA",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['ca'].toString(),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(
                    Text(
                      "AA",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['aa'].toString(),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(
                    Text(
                      "Attendance",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['attendance'].toString(),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      _totalMarks(studentMarks).toString(),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(
                    Text(
                      "Grade",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['grade'],
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
              ],
            ),
          );
  }

  num _totalMarks(Map<String, dynamic> studentMarks) {
    num ct1 = studentMarks["ct1"];
    num ct2 = studentMarks["ct2"];
    num total = max(ct1, ct2) +
        studentMarks["ca"] +
        studentMarks["dha"] +
        studentMarks["aa"] +
        studentMarks["attendance"];
    return total;
  }

  void _logout() async {
    final storage = new FlutterSecureStorage();
    await storage.deleteAll();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (BuildContext context) {
        return const Login();
      },
    ), (route) => false);
  }
}
