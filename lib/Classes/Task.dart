final String tasksTable = 'tasks';

class TaskFields {
  static final List<String> values = [id, goalFK, weekFK, title, description, effort, benefit, isRepeating, isFinished, createdTime];
  static final String id = '_id';
  static final String goalFK = 'goalFK';
  static final String weekFK = 'weekFK';
  static final String title = 'title';
  static final String description = 'description';
  static final String effort = 'effort';
  static final String benefit = 'benefit';
  static final String isRepeating = 'isRepeating';
  static final String isFinished = 'isFinished';
  static final String createdTime = 'createdTime';
}

class Task {
  int? id;
  int? goalFK;
  int? weekFK;
  String title;
  String? description;
  int effort;
  int benefit;
  bool isRepeating;
  bool isFinished;
  DateTime? createdTime;

  Task({
    this.id,
    this.goalFK,
    this.weekFK,
    this.title = "",
    this.description,
    this.effort = 1,
    this.benefit = 1,
    this.isRepeating = false,
    this.isFinished = false,
    this.createdTime,
  });

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.goalFK: goalFK,
        TaskFields.weekFK: weekFK,
        TaskFields.title: title,
        TaskFields.description: description,
        TaskFields.effort: effort,
        TaskFields.benefit: benefit,
        TaskFields.isRepeating: isRepeating ? 1 : 0,
        TaskFields.isFinished: isFinished ? 1 : 0,
        TaskFields.createdTime: createdTime!.toIso8601String(),
      };

  Task copy({
    int? id,
    int? goalFK,
    int? weekFK,
    String? title,
    String? description,
    int? effort,
    int? benefit,
    bool? isRepeating,
    bool? isFinished,
    DateTime? createdTime,
  }) =>
      Task(
        id: id ?? this.id,
        goalFK: goalFK ?? this.goalFK,
        weekFK: weekFK ?? this.weekFK,
        title: title ?? this.title,
        description: description ?? this.description,
        effort: effort ?? this.effort,
        benefit: benefit ?? this.benefit,
        isRepeating: isRepeating ?? this.isRepeating,
        isFinished: isFinished ?? this.isFinished,
        createdTime: createdTime ?? this.createdTime,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TaskFields.id] as int,
        goalFK: json[TaskFields.goalFK] as int?,
        weekFK: json[TaskFields.weekFK] as int?,
        title: json[TaskFields.title] as String,
        description: json[TaskFields.description] as String?,
        effort: json[TaskFields.effort] as int,
        benefit: json[TaskFields.benefit] as int,
        isRepeating: json[TaskFields.isRepeating] == 1,
        isFinished: json[TaskFields.isFinished] == 1,
        createdTime: DateTime.parse(json[TaskFields.createdTime] as String),
      );
}
