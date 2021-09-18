final String tasksTable = 'tasks';

class TaskFields {
  static final List<String> values = [ id, goalFK, title, input, output, isRepeating, createdTime];
  static final String id = '_id';
  static final String goalFK = 'goalFK';
  static final String title = 'title';
  static final String input = 'input';
  static final String output = 'output';
  static final String isRepeating = 'isRepeating';
  static final String createdTime = 'createdTime';
}

class Task {
  int? id;
  int? goalFK;
  String title;
  int input;
  int output;
  bool isRepeating;
  DateTime createdTime;

  Task({
    this.id,
    this.goalFK,
    required this.title,
    required this.input,
    required this.output,
    required this.isRepeating,
    required this.createdTime,
  });

  Map<String, Object?> toJson() =>
      {
        TaskFields.id: id,
        TaskFields.goalFK: goalFK,
        TaskFields.title: title,
        TaskFields.input: input,
        TaskFields.output: output,
        TaskFields.isRepeating: isRepeating ? 1 : 0,
        TaskFields.createdTime: createdTime.toIso8601String(),
      };

  Task copy({
    int? id,
    int? goalFK,
    String? title,
    int? input,
    int? output,
    bool? isRepeating,
    DateTime? createdTime,
  }) =>
      Task(
        id: id ?? this.id,
        goalFK: goalFK ?? this.goalFK,
        title: title ?? this.title,
        input: input ?? this.input,
        output: output ?? this.output,
        isRepeating: isRepeating ?? this.isRepeating,
        createdTime: createdTime ?? this.createdTime,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
    id: json[TaskFields.id] as int,
    goalFK: json[TaskFields.goalFK] as int?,
    title: json[TaskFields.title] as String,
    input: json[TaskFields.input] as int,
    output: json[TaskFields.output] as int,
    isRepeating: json[TaskFields.isRepeating] == 1,
    createdTime: DateTime.parse(json[TaskFields.createdTime] as String),
  );
}
