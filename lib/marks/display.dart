import 'dart:math';

import 'package:cms/db/mongodb.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('CMS'),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: courseCode,
                    decoration: InputDecoration(
                      labelText: "Course Code",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                    onPressed: () => _getSubject(
                        md.ObjectId.fromHexString(user["user"]),
                        courseCode.text),
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
    );
  }

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
            child: Table(
              children: [
                TableRow(children: [
                  Text(
                    "Components",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Marks",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "CT1",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    studentMarks['ct1'].toString(),
                    style: TextStyle(fontSize: 15.0),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "CT2",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    studentMarks['ct2'].toString(),
                    style: TextStyle(fontSize: 15.0),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "DHA",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    studentMarks['dha'].toString(),
                    style: TextStyle(fontSize: 15.0),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "CA",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    studentMarks['ca'].toString(),
                    style: TextStyle(fontSize: 15.0),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "AA",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    studentMarks['aa'].toString(),
                    style: TextStyle(fontSize: 15.0),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "Attendance",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    studentMarks['attendance'].toString(),
                    style: TextStyle(fontSize: 15.0),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    _totalMarks(studentMarks).toString(),
                    style: TextStyle(fontSize: 15.0),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "Grade",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    studentMarks['grade'],
                    style: TextStyle(fontSize: 15.0),
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
