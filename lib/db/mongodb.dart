import 'dart:developer';
import 'package:cms/db/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  static Future<dynamic> login(String username, String password) async {
    try {
      Map<String, dynamic>? user = await users.findOne({"username": username});
      if (user == null) {
        return false;
      }

      if (password != user["password"]) {
        return false;
      }

      final data = {
        "user": user["_id"],
        "userType": user["userType"],
        "username": user["username"],
        "name": user["name"]
      };
      final jwt = JWT(data);
      final authtoken = jwt.sign(SecretKey(jwt_secret));

      saveState(authtoken);
      return authtoken;
    } catch (e) {
      return "Something went wrong";
    }
  }

  static Future<void> saveState(String user) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "user", value: user);
  }

  static Future<String?> getState() async {
    const storage = FlutterSecureStorage();
    String? user = await storage.read(key: "user");
    return user;
  }

  static dynamic verifyToken(String token) {
    final jwt = JWT.verify(token, SecretKey(jwt_secret));
    return jwt.payload;
  }
}
