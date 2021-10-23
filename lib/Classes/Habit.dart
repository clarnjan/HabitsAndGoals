final String habitsTable = 'habits';

class HabitFields {
  static final List<String> values = [id, title, description, effortSingle, benefitSingle, repetitions, isPaused, createdTime];
  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String effortSingle = 'effortSingle';
  static final String benefitSingle = 'benefitSingle';
  static final String repetitions = 'repetitions';
  static final String isPaused = 'isPaused';
  static final String createdTime = 'createdTime';
}

class Habit {
  int? id;
  String title;
  String? description;
  int effortSingle;
  int benefitSingle;
  int repetitions;
  bool isPaused;
  DateTime? createdTime;

  Habit({
    this.id,
    this.title = "",
    this.description,
    this.effortSingle = 1,
    this.benefitSingle = 1,
    this.repetitions = 1,
    this.isPaused = false,
    this.createdTime,
  });

  Map<String, Object?> toJson() => {
        HabitFields.id: id,
        HabitFields.title: title,
        HabitFields.description: description,
        HabitFields.effortSingle: effortSingle,
        HabitFields.benefitSingle: benefitSingle,
        HabitFields.repetitions: repetitions,
        HabitFields.isPaused: isPaused ? 1 : 0,
        HabitFields.createdTime: createdTime!.toIso8601String(),
      };

  Habit copy(
          {int? id,
          String? title,
          String? description,
          int? effortSingle,
          int? benefitSingle,
          int? repetitions,
          bool? isPaused,
          DateTime? createdTime}) =>
      Habit(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        effortSingle: effortSingle ?? this.effortSingle,
        benefitSingle: benefitSingle ?? this.benefitSingle,
        repetitions: repetitions ?? this.repetitions,
        isPaused: isPaused ?? this.isPaused,
        createdTime: createdTime ?? this.createdTime,
      );

  static Habit fromJson(Map<String, Object?> json) => Habit(
        id: json[HabitFields.id] as int,
        title: json[HabitFields.title] as String,
        description: json[HabitFields.description] as String?,
        effortSingle: json[HabitFields.effortSingle] as int,
        benefitSingle: json[HabitFields.benefitSingle] as int,
        repetitions: json[HabitFields.repetitions] as int,
        isPaused: json[HabitFields.isPaused] == 1,
        createdTime: DateTime.parse(json[HabitFields.createdTime] as String),
      );
}
