//Име на табелата
final String weeklyHabitsTable = 'weeklyHabits';

//Помошна класа со статични променливи за имињата на колоните
class WeeklyHabitFields {
  static final List<String> values = [
    id,
    habitFK,
    weekFK,
    repetitionsDone,
    dayOne,
    dayTwo,
    dayThree,
    dayFour,
    dayFive,
    daySix,
    daySeven
  ];
  static final String id = '_id';
  static final String habitFK = 'habitFK';
  static final String weekFK = 'weekFK';
  static final String repetitionsDone = 'repetitionsDone';
  static final String dayOne = 'dayOne';
  static final String dayTwo = 'dayTwo';
  static final String dayThree = 'dayThree';
  static final String dayFour = 'dayFour';
  static final String dayFive = 'dayFive';
  static final String daySix = 'daySix';
  static final String daySeven = 'daySeven';
}

//Класа која ја претставува табелата WeeklyHabits
class WeeklyHabit {
  int? id;
  int habitFK;
  int weekFK;
  int repetitionsDone;
  List<bool> days;

  WeeklyHabit({
    this.id,
    required this.habitFK,
    required this.weekFK,
    required this.repetitionsDone,
    required this.days,
  });

  Map<String, Object?> toJson() => {
        WeeklyHabitFields.id: id,
        WeeklyHabitFields.habitFK: habitFK,
        WeeklyHabitFields.weekFK: weekFK,
        WeeklyHabitFields.repetitionsDone: repetitionsDone,
        WeeklyHabitFields.dayOne: days[0] ? 1 : 0,
        WeeklyHabitFields.dayTwo: days.length > 1
            ? days[1]
                ? 1
                : 0
            : null,
        WeeklyHabitFields.dayThree: days.length > 2
            ? days[2]
                ? 1
                : 0
            : null,
        WeeklyHabitFields.dayFour: days.length > 3
            ? days[3]
                ? 1
                : 0
            : null,
        WeeklyHabitFields.dayFive: days.length > 4
            ? days[4]
                ? 1
                : 0
            : null,
        WeeklyHabitFields.daySix: days.length > 5
            ? days[5]
                ? 1
                : 0
            : null,
        WeeklyHabitFields.daySeven: days.length > 6
            ? days[6]
                ? 1
                : 0
            : null,
      };

  WeeklyHabit copy({
    int? id,
    int? habitFK,
    int? weekFK,
    int? finishedTimes,
    List<bool>? days,
  }) =>
      WeeklyHabit(
          id: id ?? this.id,
          habitFK: habitFK ?? this.habitFK,
          weekFK: weekFK ?? this.weekFK,
          repetitionsDone: finishedTimes ?? this.repetitionsDone,
          days: days ?? this.days);

  static WeeklyHabit fromJson(Map<String, Object?> json) {
    List<bool> days = [];
    if (json[WeeklyHabitFields.dayOne] != null)
      days.add(json[WeeklyHabitFields.dayOne] == 1);
    if (json[WeeklyHabitFields.dayTwo] != null)
      days.add(json[WeeklyHabitFields.dayTwo] == 1);
    if (json[WeeklyHabitFields.dayThree] != null)
      days.add(json[WeeklyHabitFields.dayThree] == 1);
    if (json[WeeklyHabitFields.dayFour] != null)
      days.add(json[WeeklyHabitFields.dayFour] == 1);
    if (json[WeeklyHabitFields.dayFive] != null)
      days.add(json[WeeklyHabitFields.dayFive] == 1);
    if (json[WeeklyHabitFields.daySix] != null)
      days.add(json[WeeklyHabitFields.daySix] == 1);
    if (json[WeeklyHabitFields.daySeven] != null)
      days.add(json[WeeklyHabitFields.daySeven] == 1);
    return WeeklyHabit(
      id: json[WeeklyHabitFields.id] as int,
      habitFK: json[WeeklyHabitFields.habitFK] as int,
      weekFK: json[WeeklyHabitFields.weekFK] as int,
      repetitionsDone: json[WeeklyHabitFields.repetitionsDone] as int,
      days: days,
    );
  }
}
