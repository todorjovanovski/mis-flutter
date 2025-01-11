// Database Service
import 'package:lab4/models/exam.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'exams.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE exams (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            date_time TEXT,
            location_lat REAL,
            location_lng REAL
          )''');
      },
    );
  }

  Future<void> insertExam(Exam exam) async {
    final db = await database;
    await db.insert('exams', exam.toMap());
  }

  Future<List<Exam>> fetchExams() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('exams');
    return List.generate(maps.length, (i) {
      return Exam.fromMap(maps[i]);
    });
  }

  Future<void> deleteExam(int id) async {
    final db = await database;
    await db.delete('exams', where: 'id = ?', whereArgs: [id]);
  }
}