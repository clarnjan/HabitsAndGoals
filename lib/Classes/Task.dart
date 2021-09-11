final String tasksTable = 'tasks';

class TaskFields {
  static final List<String> values = [ id, goalFK, title, isRepeating, createdTime];
  static final String id = '_id';
  static final String goalFK = 'goalFK';
  static final String title = 'title';
  static final String isRepeating = 'isRepeating';
  static final String createdTime = 'createdTime';
}

class Task {
  int? id;
  int? goalFK;
  String title;
  bool isRepeating;
  DateTime createdTime;

  Task({
    this.id,
    this.goalFK,
    required this.title,
    required this.isRepeating,
    required this.createdTime,
  });

  Map<String, Object?> toJson() =>
      {
        TaskFields.id: id,
        TaskFields.goalFK: goalFK,
        TaskFields.title: title,
        TaskFields.isRepeating: isRepeating ? 1 : 0,
        TaskFields.createdTime: createdTime.toIso8601String(),
      };

  Task copy({
    int? id,
    int? goalFK,
    String? title,
    bool? isRepeating,
    DateTime? createdTime,
  }) =>
      Task(
        id: id ?? this.id,
        goalFK: goalFK ?? this.goalFK,
        title: title ?? this.title,
        isRepeating: isRepeating ?? this.isRepeating,
        createdTime: createdTime ?? this.createdTime,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
    id: json[TaskFields.id] as int,
    goalFK: json[TaskFields.goalFK] as int?,
    title: json[TaskFields.title] as String,
    isRepeating: json[TaskFields.isRepeating] == 1,
    createdTime: DateTime.parse(json[TaskFields.createdTime] as String),
  );
}
