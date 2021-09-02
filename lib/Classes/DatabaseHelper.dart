import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null)
      return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    return db.execute('''
        CREATE TABLE $tasksTable (
          ${TaskFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${TaskFields.title} TEXT NOT NULL,
          ${TaskFields.description} Text,
          ${TaskFields.input} INTEGER NOT NULL,
          ${TaskFields.output} INTEGER NOT NULL,
          ${TaskFields.finished} BOOLEAN NOT NULL,
          ${TaskFields.createdTime} TEXT NOT NULL,
          ${TaskFields.finishedTime} TEXT
          )'''
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert(tasksTable, task.toJson());
    return task.copy(id: id);
  }

  Future<Task> getTask(int id) async {
    final db = await instance.database;
    final result = await db.query(tasksTable,columns: TaskFields.values, where: '${TaskFields.id} = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Task.fromJson(result.first);
    } else {
      throw Exception('ID: $id not found');
    }
  }

  Future<List<Task>> getAllTasks() async {
    final db = await instance.database;
    final result = await db.query(tasksTable);
    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return db.update(tasksTable, task.toJson(), where: '${TaskFields.id} = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(tasksTable, where: '${TaskFields.id} = ?', whereArgs: [id]);
  }
}