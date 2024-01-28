import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../context/auth/auth_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    var user = Provider.of<AuthProvider>(context);

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
            children: const [
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
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: courseCode,
                      decoration: InputDecoration(
                        labelText: "Course Code",
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(30)),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      onPressed: isValid
                          ? () =>
                              fetchMarks(context, courseCode.text.toUpperCase())
                          : null,
                      child: const Text("Submit"))
                ],
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.all(15),
                child: displayMarksTable(studentMarks),
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget drawerDetails(dynamic user) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context, user),
            buildMenuItems(context, user),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, dynamic user) => Container(
        color: const Color.fromARGB(190, 0, 0, 0),
        padding: EdgeInsets.only(
            top: 20 + MediaQuery.of(context).padding.top, bottom: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Text(
                "${user.name[0].toUpperCase()}",
                style: const TextStyle(fontSize: 40, color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${user.name}",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "${user.username}",
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "${user.userType}"[0].toUpperCase() +
                  "${user.userType}".substring(1),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context, dynamic user) => Column(
        children: [
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout", style: TextStyle(fontSize: 15)),
              onTap: () => user.logoutUser(context))
        ],
      );

  Future<void> fetchMarks(BuildContext context, String courseCode) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: "token");
      final response = await http.get(
        Uri.parse('http://192.168.19.239:5000/api/marks/my-marks/$courseCode'),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': token ?? "",
        },
      );

      final Map<String, dynamic> json = jsonDecode(response.body);
      if (json['success']) {
        studentMarks = json['marks'];
        setState(() => isVisible = true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${json['error']}")));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Internal Server Error: $error')));
    }
  }

  Widget displayMarksTable(var studentMarks) {
    return studentMarks == null
        ? const Text("No Records to display")
        : Visibility(
            visible: isVisible,
            child: DataTable(
              columns: const [
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
                  const DataCell(
                    Text(
                      "CT1",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['ct1'].toString(),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(
                    Text(
                      "CT2",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['ct2'].toString(),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(
                    Text(
                      "DHA",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['dha'].toString(),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(
                    Text(
                      "CA",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['ca'].toString(),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(
                    Text(
                      "AA",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['aa'].toString(),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(
                    Text(
                      "Attendance",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['attendance'].toString(),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      _totalMarks(studentMarks).toString(),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(
                    Text(
                      "Grade",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  DataCell(
                    Text(
                      studentMarks['grade'],
                      style: const TextStyle(fontSize: 15.0),
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
}
