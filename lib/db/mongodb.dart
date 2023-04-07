import 'dart:developer';
import 'package:cms/db/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  // ignore: prefer_typing_uninitialized_variables
  static var db, users, marks, subjects;

  static connect() async {
    db = await Db.create(mongoURI);
    await db.open();
    inspect(db);
    users = db.collection(usersCollection);
    marks = db.collection(marksCollection);
    subjects = db.collection(subjectsCollection);
  }

  static Future<dynamic> getSubject(String courseCode) async {
    var subject = await subjects.findOne({"courseCode": courseCode});
    if (subject == null)
      return 0;
    else {
      Map<String, dynamic> subjectDetails = {
        "id": subject["_id"],
        "courseName": subject["courseName"],
      };
      return subjectDetails;
    }
  }

  static Future<dynamic> getMarks(ObjectId student, ObjectId courseId) async {
    var record = await marks.findOne({"subject": courseId, "student": student});
    if (record == null) {
      return 0;
    } else {
      Map<String, dynamic> marksDetails = {
        "ct1": record["ct1"],
        "ct2": record["ct2"],
        "ca": record["ca"],
        "dha": record["dha"],
        "aa": record["aa"],
        "attendance": record["attendance"],
        "grade": record["grade"],
      };
      return marksDetails;
    }
  }
}
