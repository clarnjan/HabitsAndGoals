import 'package:diplomska1/Classes/DateService.dart';
import 'package:diplomska1/Classes/Goal.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:diplomska1/Classes/WeeklyTask.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
        CREATE TABLE $weeksTable (
          ${WeekFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${WeekFields.title} TEXT NOT NULL,
          ${WeekFields.startDate} TEXT UNIQUE NOT NULL,
          ${WeekFields.endDate} TEXT UNIQUE NOT NULL
        );''');
    batch.execute('''
        CREATE TABLE $goalsTable (
          ${GoalFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${GoalFields.title} TEXT NOT NULL,
          ${GoalFields.description} TEXT NULL,
          ${GoalFields.isFinished} BOOLEAN NOT NULL,
          ${GoalFields.createdTime} TEXT NOT NULL
        );''');
    batch.execute('''
        CREATE TABLE $habitsTable (
          ${HabitFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${HabitFields.title} TEXT NOT NULL,
          ${HabitFields.description} TEXT NULL,
          ${HabitFields.effortSingle} INTEGER NOT NULL,
          ${HabitFields.benefitSingle} INTEGER NOT NULL,
          ${HabitFields.repetitions} INTEGER NOT NULL,
          ${HabitFields.isPaused} BOOLEAN NOT NULL,
          ${HabitFields.createdTime} TEXT NOT NULL
        );''');
    batch.execute('''
        CREATE TABLE $tasksTable (
          ${TaskFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${TaskFields.title} TEXT NOT NULL,
          ${TaskFields.description} TEXT NULL,
          ${TaskFields.goalFK} INTEGER,
          ${TaskFields.effort} INTEGER NOT NULL,
          ${TaskFields.benefit} INTEGER NOT NULL,
          ${TaskFields.isRepeating} BOOLEAN NOT NULL,
          ${TaskFields.isFinished} BOOLEAN NOT NULL,
          ${TaskFields.createdTime} TEXT NOT NULL,
          FOREIGN KEY(${TaskFields.goalFK}) REFERENCES $goalsTable(${GoalFields.id})
        );''');
    batch.execute('''
        CREATE TABLE $weeklyTasksTable (
          ${WeeklyTaskFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${WeeklyTaskFields.taskFK} INTEGER NOT NULL,
          ${WeeklyTaskFields.weekFK} INTEGER NOT NULL,
          ${WeeklyTaskFields.isFinished} BOOLEAN NOT NULL,
          FOREIGN KEY(${WeeklyTaskFields.taskFK}) REFERENCES $tasksTable(${TaskFields.id}),
          FOREIGN KEY(${WeeklyTaskFields.weekFK}) REFERENCES $weeksTable(${WeekFields.id})
        );''');
    batch.execute('''
        CREATE TABLE $weeklyHabitsTable (
          ${WeeklyHabitFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${WeeklyHabitFields.habitFK} INTEGER NOT NULL,
          ${WeeklyHabitFields.weekFK} INTEGER NOT NULL,
          ${WeeklyHabitFields.repetitionsDone} INTEGER NOT NULL,
          ${WeeklyHabitFields.dayOne} BOOLEAN NULL DEFAULT NULL,
          ${WeeklyHabitFields.dayTwo} BOOLEAN NULL DEFAULT NULL,
          ${WeeklyHabitFields.dayThree} BOOLEAN NULL DEFAULT NULL,
          ${WeeklyHabitFields.dayFour} BOOLEAN NULL DEFAULT NULL,
          ${WeeklyHabitFields.dayFive} BOOLEAN NULL DEFAULT NULL,
          ${WeeklyHabitFields.daySix} BOOLEAN NULL DEFAULT NULL,
          ${WeeklyHabitFields.daySeven} BOOLEAN NULL DEFAULT NULL,
          FOREIGN KEY(${WeeklyHabitFields.habitFK}) REFERENCES $habitsTable(${HabitFields.id}),
          FOREIGN KEY(${WeeklyHabitFields.weekFK}) REFERENCES $weeksTable(${WeekFields.id})
        );''');
    var result = await batch.commit();
    DateTime today = DateTime.now();
    DateTime startDate = DateUtils.dateOnly(today.subtract(Duration(days: today.weekday - 1)));
    DateTime endDate = DateService.getEndDate(startDate);
    Week week = new Week(
        title: "Week ${DateService.formatDate(startDate)} - ${DateService.formatDate(endDate)}", startDate: startDate, endDate: endDate);
    await db.insert(weeksTable, week.toJson());
    return result;
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

  Future<List<Habit>> getAllHabits() async {
    final db = await instance.database;
    final result = await db.query(habitsTable);
    return result.map((json) => Habit.fromJson(json)).toList();
  }

  Future<List<Task>> getAllTasks() async {
    final db = await instance.database;
    final result = await db.query(tasksTable);
    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<List<Goal>> getAllGoals() async {
    final db = await instance.database;
    final result = await db.query(goalsTable);
    return result.map((json) => Goal.fromJson(json)).toList();
  }

  Future<Week> getWeek(int id) async {
    final db = await instance.database;
    final result = await db.query(weeksTable, columns: WeekFields.values, where: '${WeekFields.id} = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      Week week = Week.fromJson(result.first);
      week.habits = await getWeeklyHabitsForWeek(id);
      week.tasks = await getWeeklyTasksForWeek(id);
      return week;
    } else {
      throw Exception('ID: $id not found');
    }
  }

  Future<Week> getWeekByStartDate(DateTime startDate) async {
    final db = await instance.database;
    final result = await db.query(weeksTable, columns: WeekFields.values);
    Week? currentWeek;
    if (result.isNotEmpty) {
      for (Map<String, Object?> r in result) {
        Week week = Week.fromJson(r);
        if (week.startDate.year == startDate.year && week.startDate.month == startDate.month && week.startDate.day == startDate.day) {
          currentWeek = week;
          break;
        }
      }
      if (currentWeek == null) {
        DateTime endDate = DateService.getEndDate(startDate);
        currentWeek = new Week(
            title: "Week ${DateService.formatDate(startDate)} - ${DateService.formatDate(endDate)}",
            startDate: startDate,
            endDate: endDate);
        currentWeek.id = await db.insert(weeksTable, currentWeek.toJson());
      }
      currentWeek.habits = await getWeeklyHabitsForWeek(currentWeek.id!);
      currentWeek.tasks = await getWeeklyTasksForWeek(currentWeek.id!);
      return currentWeek;
    }
    throw Exception("Error occurred");
  }

  Future<Week> getCurrentWeek() async {
    DateTime today = DateTime.now();
    DateTime startDate = DateUtils.dateOnly(today.subtract(Duration(days: today.weekday - 1)));
    return await getWeekByStartDate(startDate);
  }

  Future<List<WeeklyHabit>> getWeeklyHabitsForWeek(int weekId) async {
    final db = await instance.database;
    final result =
        await db.query(weeklyHabitsTable, columns: WeeklyHabitFields.values, where: '${WeeklyHabitFields.weekFK} = ?', whereArgs: [weekId]);
    return result.map((json) => WeeklyHabit.fromJson(json)).toList();
  }

  Future<List<WeeklyHabit>> getWeeklyHabitsForHabit(int habitId) async {
    final db = await instance.database;
    final result = await db
        .query(weeklyHabitsTable, columns: WeeklyHabitFields.values, where: '${WeeklyHabitFields.habitFK} = ?', whereArgs: [habitId]);
    return result.map((json) => WeeklyHabit.fromJson(json)).toList();
  }

  Future<List<WeeklyTask>> getWeeklyTasksForWeek(int weekId) async {
    final db = await instance.database;
    final result =
        await db.query(weeklyTasksTable, columns: WeeklyTaskFields.values, where: '${WeeklyTaskFields.weekFK} = ?', whereArgs: [weekId]);
    return result.map((json) => WeeklyTask.fromJson(json)).toList();
  }

  Future<List<Task>> getTasksForGoal(int goalId) async {
    final db = await instance.database;
    final result = await db.query(tasksTable, columns: TaskFields.values, where: '${TaskFields.goalFK} = ?', whereArgs: [goalId]);
    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<Habit> getHabit(int id) async {
    final db = await instance.database;
    final result = await db.query(habitsTable, columns: HabitFields.values, where: '${HabitFields.id} = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Habit.fromJson(result.first);
    } else {
      throw Exception('ID: $id not found');
    }
  }

  Future<Task> getTask(int id) async {
    final db = await instance.database;
    final result = await db.query(tasksTable, columns: TaskFields.values, where: '${TaskFields.id} = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Task.fromJson(result.first);
    } else {
      throw Exception('ID: $id not found');
    }
  }

  Future<Goal> getGoal(int id) async {
    final db = await instance.database;
    final result = await db.query(goalsTable, columns: GoalFields.values, where: '${GoalFields.id} = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      Goal goal = Goal.fromJson(result.first);
      goal.tasks = await getTasksForGoal(id);
      return goal;
    } else {
      throw Exception('ID: $id not found');
    }
  }

  Future<WeeklyHabit> getWeeklyHabit(int weekId, int habitId) async {
    final db = await instance.database;
    final result = await db.query(weeklyHabitsTable,
        columns: WeeklyHabitFields.values,
        where: '${WeeklyHabitFields.weekFK} = ? AND ${WeeklyHabitFields.habitFK} = ?',
        whereArgs: [weekId, habitId]);
    if (result.isNotEmpty) {
      return WeeklyHabit.fromJson(result.first);
    } else {
      throw Exception('Weekly habit not found');
    }
  }

  Future<WeeklyTask> getWeeklyTask(int weekId, int taskId) async {
    final db = await instance.database;
    final result = await db.query(weeklyTasksTable,
        columns: WeeklyTaskFields.values,
        where: '${WeeklyTaskFields.weekFK} = ? AND ${WeeklyTaskFields.taskFK} = ?',
        whereArgs: [weekId, taskId]);
    if (result.isNotEmpty) {
      return WeeklyTask.fromJson(result.first);
    } else {
      throw Exception('Weekly task not found');
    }
  }

  Future<Week> createWeek(Week week) async {
    final db = await instance.database;
    final id = await db.insert(weeksTable, week.toJson());
    week.habits = await getWeeklyHabitsForWeek(id);
    return week.copy(id: id);
  }

  Future<Habit> createHabit(Habit habit) async {
    final db = await instance.database;
    final id = await db.insert(habitsTable, habit.toJson());
    return habit.copy(id: id);
  }

  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert(tasksTable, task.toJson());
    return task.copy(id: id);
  }

  Future<Goal> createGoal(Goal goal) async {
    final db = await instance.database;
    final id = await db.insert(goalsTable, goal.toJson());
    return goal.copy(id: id);
  }

  Future<WeeklyHabit> createWeeklyHabit(WeeklyHabit weeklyHabit) async {
    final db = await instance.database;
    final id = await db.insert(weeklyHabitsTable, weeklyHabit.toJson());
    return weeklyHabit.copy(id: id);
  }

  Future<WeeklyTask> createWeeklyTask(WeeklyTask weeklyTask) async {
    final db = await instance.database;
    final id = await db.insert(weeklyTasksTable, weeklyTask.toJson());
    return weeklyTask.copy(id: id);
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return db.update(tasksTable, task.toJson(), where: '${TaskFields.id} = ?', whereArgs: [task.id]);
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await instance.database;
    return db.update(habitsTable, habit.toJson(), where: '${HabitFields.id} = ?', whereArgs: [habit.id]);
  }

  Future<int> updateGoal(Goal goal) async {
    final db = await instance.database;
    return db.update(goalsTable, goal.toJson(), where: '${GoalFields.id} = ?', whereArgs: [goal.id]);
  }

  Future<int> deleteHabit(int id) async {
    final db = await instance.database;
    db.delete(weeklyHabitsTable, where: '${WeeklyHabitFields.habitFK} = ?', whereArgs: [id]);
    return await db.delete(habitsTable, where: '${HabitFields.id} = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    db.delete(weeklyTasksTable, where: '${WeeklyTaskFields.taskFK} = ?', whereArgs: [id]);
    return await db.delete(tasksTable, where: '${TaskFields.id} = ?', whereArgs: [id]);
  }

  Future<int> deleteGoal(int id) async {
    final db = await instance.database;
    return await db.delete(goalsTable, where: '${GoalFields.id} = ?', whereArgs: [id]);
  }

  Future<int> updateWeeklyHabit(WeeklyHabit weeklyHabit) async {
    final db = await instance.database;
    return db.update(weeklyHabitsTable, weeklyHabit.toJson(), where: '${WeeklyHabitFields.id} = ?', whereArgs: [weeklyHabit.id]);
  }

  Future<int> updateWeeklyTask(WeeklyTask weeklyTask) async {
    final db = await instance.database;
    return db.update(weeklyTasksTable, weeklyTask.toJson(), where: '${WeeklyTaskFields.id} = ?', whereArgs: [weeklyTask.id]);
  }
}
