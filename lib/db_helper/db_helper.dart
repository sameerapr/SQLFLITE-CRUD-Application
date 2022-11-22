import 'dart:io';

import 'package:flutter_application_3/model/student_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'student.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE student_details(
          id INTEGER PRIMARY KEY AUTO_INCREMENT,
          name TEXT,
          course Text
      )
      ''');
  }

  Future<List<Student>> getStudentDetails() async {
    Database db = await instance.database;
    var _student = await db.query('student_details', orderBy: 'name');
    List<Student> _studentList = _student.isNotEmpty
        ? _student.map((c) => Student.fromMap(c)).toList()
        : [];
    return _studentList;
  }

  Future<int> add(Student grocery) async {
    Database db = await instance.database;
    return await db.insert('student_details', grocery.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('student_details', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Student>> getStudentDetailsById(String name) async {
    Database db = await instance.database;
    var _studentDetails =
        await db.query('student_details', where: 'name = ?', whereArgs: [name]);
    List<Student> _studentDetailsList = _studentDetails.isNotEmpty
        ? _studentDetails.map((c) => Student.fromMap(c)).toList()
        : [];
    return _studentDetailsList;
  }

  Future<int> update(Student student) async {
    Database db = await instance.database;
    return await db.update('student_details', student.toMap(),
        where: "id = ?", whereArgs: [student.id]);
  }
}
