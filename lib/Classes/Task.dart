final String tasksTable = 'tasks';

class TaskFields {
  static final List<String> values = [ id, title, description, input, output, finished, createdTime, finishedTime];
  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String input = 'input';
  static final String output = 'output';
  static final String finished = 'finished';
  static final String createdTime = 'createdTime';
  static final String finishedTime = 'finishedTime';
}

class Task {
  int? id;
  String title;
  String? description;
  int input;
  int output;
  bool finished;
  DateTime createdTime;
  DateTime? finishedTime;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.input,
    required this.output,
    required this.finished,
    required this.createdTime,
    this.finishedTime});

  Map<String, Object?> toJson() =>
      {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.description: description,
        TaskFields.input: input,
        TaskFields.output: output,
        TaskFields.finished: finished ? 1 : 0,
        TaskFields.createdTime: createdTime.toIso8601String(),
        TaskFields.finishedTime: finishedTime?.toIso8601String(),
      };

  Task copy({
    int? id,
    String? title,
    String? description,
    int? input,
    int? output,
    bool? finished,
    DateTime? createdTime,
    DateTime? finishedTime
  }) =>
      Task(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          input: input ?? this.input,
          output: output ?? this.output,
          finished: finished ?? this.finished,
          createdTime: createdTime ?? this.createdTime,
          finishedTime: finishedTime ?? this.finishedTime
      );

  static Task fromJson(Map<String, Object?> json) => Task(
    id: json[TaskFields.id] as int,
    title: json[TaskFields.title] as String,
    description: json[TaskFields.description] as String?,
    input: json[TaskFields.input] as int,
    output: json[TaskFields.output] as int,
    finished: json[TaskFields.finished] == 1,
    createdTime: DateTime.parse(json[TaskFields.createdTime] as String),
    finishedTime: json[TaskFields.finishedTime] != null ? DateTime.parse(json[TaskFields.finishedTime] as String) : null,
  );
}
