final String weeklyTasksTable = 'weeklyTasks';

class WeeklyTaskFields {
  static final List<String> values = [ id, taskFK, weekFK, isFinished];
  static final String id = '_id';
  static final String taskFK = 'taskFK';
  static final String weekFK = 'weekFK';
  static final String isFinished = 'finished';
}

class WeeklyTask {
  int? id;
  int taskFK;
  int weekFK;
  bool isFinished;

  WeeklyTask({
    this.id,
    required this.taskFK,
    required this.weekFK,
    required this.isFinished
  });

  Map<String, Object?> toJson() =>
      {
        WeeklyTaskFields.id: id,
        WeeklyTaskFields.taskFK: taskFK,
        WeeklyTaskFields.weekFK: weekFK,
        WeeklyTaskFields.isFinished: isFinished ? 1 : 0
      };

  WeeklyTask copy({
    int? id,
    int? taskFK,
    int? weekFK,
    bool? isFinished
  }) =>
      WeeklyTask(
          id: id ?? this.id,
          taskFK: taskFK ?? this.taskFK,
          weekFK: weekFK ?? this.weekFK,
          isFinished: isFinished ?? this.isFinished
      );

  static WeeklyTask fromJson(Map<String, Object?> json) => WeeklyTask(
    id: json[WeeklyTaskFields.id] as int,
    taskFK: json[WeeklyTaskFields.taskFK] as int,
    weekFK: json[WeeklyTaskFields.weekFK] as int,
    isFinished: json[WeeklyTaskFields.isFinished] == 1
  );
}
