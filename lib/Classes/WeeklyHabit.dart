final String weeklyHabitsTable = 'weeklyHabits';

class WeeklyHabitFields {
  static final List<String> values = [ id, habitFK, weekFK, inputSingle, outputSingle, times, finishedTimes, goalTimes];
  static final String id = '_id';
  static final String habitFK = 'habitFK';
  static final String weekFK = 'weekFK';
  static final String inputSingle = 'inputSingle';
  static final String outputSingle = 'outputSingle';
  static final String times = 'times';
  static final String finishedTimes = 'finishedTimes';
  static final String goalTimes = 'goalTimes';
}

class WeeklyHabit {
  int? id;
  int habitFK;
  int weekFK;
  int inputSingle;
  int outputSingle;
  int times;
  int finishedTimes;
  int goalTimes;

  WeeklyHabit({
    this.id,
    required this.habitFK,
    required this.weekFK,
    required this.inputSingle,
    required this.outputSingle,
    required this.times,
    required this.finishedTimes,
    required this.goalTimes,
  });

  Map<String, Object?> toJson() =>
      {
        WeeklyHabitFields.id: id,
        WeeklyHabitFields.habitFK: habitFK,
        WeeklyHabitFields.weekFK: weekFK,
        WeeklyHabitFields.inputSingle: inputSingle,
        WeeklyHabitFields.outputSingle: outputSingle,
        WeeklyHabitFields.times: times,
        WeeklyHabitFields.finishedTimes: finishedTimes,
        WeeklyHabitFields.goalTimes: goalTimes,
      };

  WeeklyHabit copy({
    int? id,
    int? habitFK,
    int? weekFK,
    int? inputSingle,
    int? outputSingle,
    int? times,
    int? finishedTimes,
    int? goalTimes,
  }) =>
      WeeklyHabit(
          id: id ?? this.id,
          habitFK: habitFK ?? this.habitFK,
          weekFK: weekFK ?? this.weekFK,
          inputSingle: inputSingle ?? this.inputSingle,
          outputSingle: outputSingle ?? this.outputSingle,
          times: times ?? this.times,
          finishedTimes: finishedTimes ?? this.finishedTimes,
          goalTimes: goalTimes ?? this.goalTimes
      );

  static WeeklyHabit fromJson(Map<String, Object?> json) => WeeklyHabit(
    id: json[WeeklyHabitFields.id] as int,
    habitFK: json[WeeklyHabitFields.habitFK] as int,
    weekFK: json[WeeklyHabitFields.weekFK] as int,
    inputSingle: json[WeeklyHabitFields.inputSingle] as int,
    outputSingle: json[WeeklyHabitFields.outputSingle] as int,
    times: json[WeeklyHabitFields.times] as int,
    finishedTimes: json[WeeklyHabitFields.finishedTimes] as int,
    goalTimes: json[WeeklyHabitFields.goalTimes] as int,
  );
}
