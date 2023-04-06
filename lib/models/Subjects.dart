import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

SubjectSchema subjectSchemaFromJson(String str) =>
    SubjectSchema.fromJson(json.decode(str));

String subjectSchemaToJson(SubjectSchema data) => json.encode(data.toJson());

class SubjectSchema {
  SubjectSchema({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.credits,
    required this.teacher,
  });

  ObjectId id;
  String courseCode;
  String courseName;
  int credits;
  ObjectId teacher;

  factory SubjectSchema.fromJson(Map<String, dynamic> json) => SubjectSchema(
        id: json["_id"],
        courseCode: json["courseCode"],
        courseName: json["courseName"],
        credits: json["credits"],
        teacher: json["teacher"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "courseCode": courseCode,
        "courseName": courseName,
        "credits": credits,
        "teacher": teacher,
      };
}
