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
}
