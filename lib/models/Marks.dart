// ignore_for_file: file_names

import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

MarksSchema marksSchemaFromJson(String str) =>
    MarksSchema.fromJson(json.decode(str));

String marksSchemaToJson(MarksSchema data) => json.encode(data.toJson());

class MarksSchema {
  MarksSchema({
    required this.id,
    required this.student,
    required this.subject,
    required this.ct1,
    required this.ct2,
    required this.ca,
    required this.dha,
    required this.aa,
    required this.attendance,
    required this.grade,
  });

  ObjectId id;
  ObjectId student;
  ObjectId subject;
  int ct1;
  int ct2;
  int ca;
  int dha;
  int aa;
  int attendance;
  String grade;

  factory MarksSchema.fromJson(Map<String, dynamic> json) => MarksSchema(
        id: json["_id"],
        student: json["student"],
        subject: json["subject"],
        ct1: json["ct1"],
        ct2: json["ct2"],
        ca: json["ca"],
        dha: json["dha"],
        aa: json["aa"],
        attendance: json["attendance"],
        grade: json["grade"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "student": student,
        "subject": subject,
        "ct1": ct1,
        "ct2": ct2,
        "ca": ca,
        "dha": dha,
        "aa": aa,
        "attendance": attendance,
        "grade": grade,
      };
}
