final String weeklyHabitsTable = 'weeklyHabits';

class WeeklyHabitFields {
  static final List<String> values = [ id, habitFK, weekFK, repetitionsDone];
  static final String id = '_id';
  static final String habitFK = 'habitFK';
  static final String weekFK = 'weekFK';
  static final String repetitionsDone = 'repetitionsDone';
}

class WeeklyHabit {
  int? id;
  int habitFK;
  int weekFK;
  int repetitionsDone;

  WeeklyHabit({
    this.id,
    required this.habitFK,
    required this.weekFK,
    required this.repetitionsDone,
  });

  Map<String, Object?> toJson() =>
      {
        WeeklyHabitFields.id: id,
        WeeklyHabitFields.habitFK: habitFK,
        WeeklyHabitFields.weekFK: weekFK,
        WeeklyHabitFields.repetitionsDone: repetitionsDone,
      };

  WeeklyHabit copy({
    int? id,
    int? habitFK,
    int? weekFK,
    int? finishedTimes,
  }) =>
      WeeklyHabit(
          id: id ?? this.id,
          habitFK: habitFK ?? this.habitFK,
          weekFK: weekFK ?? this.weekFK,
          repetitionsDone: finishedTimes ?? this.repetitionsDone,
      );

  static WeeklyHabit fromJson(Map<String, Object?> json) => WeeklyHabit(
    id: json[WeeklyHabitFields.id] as int,
    habitFK: json[WeeklyHabitFields.habitFK] as int,
    weekFK: json[WeeklyHabitFields.weekFK] as int,
    repetitionsDone: json[WeeklyHabitFields.repetitionsDone] as int,
  );
}
