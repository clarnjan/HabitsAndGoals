import 'package:diplomska1/Classes/Goal.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:diplomska1/Classes/WeeklyTask.dart';
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
        CREATE TABLE $weeksTable (
          ${WeekFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${GoalFields.title} TEXT NOT NULL,
          ${WeekFields.startDate} TEXT NOT NULL,
          ${WeekFields.endDate} TEXT NOT NULL
        );
        CREATE TABLE $goalsTable (
          ${GoalFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${GoalFields.title} TEXT NOT NULL,
          ${GoalFields.isFinished} BOOLEAN NOT NULL,
          ${GoalFields.createdTime} TEXT NOT NULL
        );
        CREATE TABLE $habitsTable (
          ${HabitFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${HabitFields.title} TEXT NOT NULL,
          ${HabitFields.createdTime} TEXT NOT NULL
        );
        CREATE TABLE $tasksTable (
          ${TaskFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${TaskFields.goalFK} INTEGER,
          ${TaskFields.title} TEXT NOT NULL,
          ${TaskFields.createdTime} TEXT NOT NULL,
          ${TaskFields.isRepeating} BOOLEAN NOT NULL,
          FOREIGN KEY(${TaskFields.goalFK}) REFERENCES $goalsTable(${GoalFields.id})
        );
        CREATE TABLE $weeklyTasksTable (
          ${WeeklyTaskFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${WeeklyTaskFields.taskFK} INTEGER NOT NULL,
          ${WeeklyTaskFields.weekFK} INTEGER NOT NULL,
          ${WeeklyTaskFields.input} INTEGER NOT NULL,
          ${WeeklyTaskFields.output} INTEGER NOT NULL,
          ${WeeklyTaskFields.isGoal} BOOLEAN NOT NULL,
          ${WeeklyTaskFields.isFinished} BOOLEAN NOT NULL,
          FOREIGN KEY(${WeeklyTaskFields.taskFK}) REFERENCES $tasksTable(${TaskFields.id}),
          FOREIGN KEY(${WeeklyTaskFields.weekFK}) REFERENCES $weeksTable(${WeekFields.id})
        );
        CREATE TABLE $weeklyHabitsTable (
          ${WeeklyHabitFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${WeeklyHabitFields.habitFK} INTEGER NOT NULL,
          ${WeeklyHabitFields.weekFK} INTEGER NOT NULL,
          ${WeeklyHabitFields.inputSingle} INTEGER NOT NULL,
          ${WeeklyHabitFields.outputSingle} INTEGER NOT NULL,
          ${WeeklyHabitFields.times} INTEGER NOT NULL,
          ${WeeklyHabitFields.finishedTimes} INTEGER NOT NULL,
          ${WeeklyHabitFields.goalTimes} INTEGER NOT NULL,
          FOREIGN KEY(${WeeklyHabitFields.habitFK}) REFERENCES $habitsTable(${HabitFields.id}),
          FOREIGN KEY(${WeeklyHabitFields.weekFK}) REFERENCES $weeksTable(${WeekFields.id})
        );'''
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<List<Week>> getAllWeeks() async {
    final db = await instance.database;
    final result = await db.query(weeksTable);
    return result.map((json) => Week.fromJson(json)).toList();
  }

  Future<List<Task>> getAllTasks() async {
    final db = await instance.database;
    final result = await db.query(tasksTable);
    return result.map((json) => Task.fromJson(json)).toList();
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

  Future<Week> createWeek(Week week) async {
    final db = await instance.database;
    final id = await db.insert(weeksTable, week.toJson());
    return week.copy(id: id);
  }

  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert(tasksTable, task.toJson());
    return task.copy(id: id);
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