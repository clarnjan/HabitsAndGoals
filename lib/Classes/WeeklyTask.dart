final String weeklyTasksTable = 'weeklyTasks';

class WeeklyTaskFields {
  static final List<String> values = [ id, taskFK, weekFK, input, output, isGoal, isFinished];
  static final String id = '_id';
  static final String taskFK = 'taskFK';
  static final String weekFK = 'weekFK';
  static final String input = 'input';
  static final String output = 'output';
  static final String isGoal = 'isGoal';
  static final String isFinished = 'finished';
}

class WeeklyTask {
  int? id;
  int taskFK;
  int weekFK;
  int input;
  int output;
  bool isGoal;
  bool isFinished;

  WeeklyTask({
    this.id,
    required this.taskFK,
    required this.weekFK,
    required this.input,
    required this.output,
    required this.isGoal,
    required this.isFinished
  });

  Map<String, Object?> toJson() =>
      {
        WeeklyTaskFields.id: id,
        WeeklyTaskFields.taskFK: taskFK,
        WeeklyTaskFields.weekFK: weekFK,
        WeeklyTaskFields.input: input,
        WeeklyTaskFields.output: output,
        WeeklyTaskFields.isGoal: isGoal ? 1 : 0,
        WeeklyTaskFields.isFinished: isFinished ? 1 : 0
      };

  WeeklyTask copy({
    int? id,
    int? taskFK,
    int? weekFK,
    int? input,
    int? output,
    bool? isGoal,
    bool? isFinished
  }) =>
      WeeklyTask(
          id: id ?? this.id,
          taskFK: taskFK ?? this.taskFK,
          weekFK: weekFK ?? this.weekFK,
          input: input ?? this.input,
          output: output ?? this.output,
          isGoal: isGoal ?? this.isGoal,
          isFinished: isFinished ?? this.isFinished
      );

  static WeeklyTask fromJson(Map<String, Object?> json) => WeeklyTask(
    id: json[WeeklyTaskFields.id] as int,
    taskFK: json[WeeklyTaskFields.taskFK] as int,
    weekFK: json[WeeklyTaskFields.weekFK] as int,
    input: json[WeeklyTaskFields.input] as int,
    output: json[WeeklyTaskFields.output] as int,
    isGoal: json[WeeklyTaskFields.isGoal] == 1,
    isFinished: json[WeeklyTaskFields.isFinished] == 1
  );
}
