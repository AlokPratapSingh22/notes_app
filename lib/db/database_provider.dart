import 'package:notes_app/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), "notes_app.db"),
        onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        creationDate DATE
      )
      ''');
    }, version: 1);
  }

  addNewNote(NoteModel note) async {
    final db = await database;
    if (db == null) return;
    db.insert("notes", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<dynamic> getNotes() async {
    final db = await database;
    if (db == null) return;
    var res = await db.query("notes");
    if (res.length == 0) return Null;
    var resultMap = res.toList();
    return resultMap.isNotEmpty ? resultMap : Null;
  }
}
