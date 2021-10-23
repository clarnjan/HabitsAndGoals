import 'package:diplomska1/Classes/Task.dart';

final String goalsTable = 'goals';

class GoalFields {
  static final List<String> values = [id, title, description, isFinished, createdTime];
  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String isFinished = 'isFinished';
  static final String createdTime = 'createdTime';
}

class Goal {
  int? id;
  String title;
  String? description;
  bool isFinished;
  DateTime? createdTime;
  late List<Task> tasks;

  Goal({
    this.id,
    this.title = "",
    this.description,
    this.isFinished = false,
    this.createdTime,
    this.tasks = const [],
  });

  Map<String, Object?> toJson() => {
        GoalFields.id: id,
        GoalFields.title: title,
        GoalFields.description: description,
        GoalFields.isFinished: isFinished ? 1 : 0,
        GoalFields.createdTime: createdTime!.toIso8601String(),
      };

  Goal copy({
    int? id,
    String? title,
    String? description,
    bool? isFinished,
    DateTime? createdTime,
  }) =>
      Goal(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isFinished: isFinished ?? this.isFinished,
        createdTime: createdTime ?? this.createdTime,
      );

  static Goal fromJson(Map<String, Object?> json) => Goal(
        id: json[GoalFields.id] as int,
        title: json[GoalFields.title] as String,
        description: json[GoalFields.description] as String?,
        isFinished: json[GoalFields.isFinished] == 1,
        createdTime: DateTime.parse(json[GoalFields.createdTime] as String),
      );
}
