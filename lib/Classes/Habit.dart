final String habitsTable = 'habits';

class HabitFields {
  static final List<String> values = [
    id,
    title,
    inputSingle,
    outputSingle,
    repetitions,
    isPaused,
    createdTime
  ];
  static final String id = '_id';
  static final String title = 'title';
  static final String inputSingle = 'inputSingle';
  static final String outputSingle = 'outputSingle';
  static final String repetitions = 'repetitions';
  static final String isPaused = 'isPaused';
  static final String createdTime = 'createdTime';
}

class Habit {
  int? id;
  String title;
  int inputSingle;
  int outputSingle;
  int repetitions;
  bool isPaused;
  DateTime createdTime;

  Habit({
    this.id,
    required this.title,
    required this.inputSingle,
    required this.outputSingle,
    required this.repetitions,
    required this.isPaused,
    required this.createdTime,
  });

  Map<String, Object?> toJson() => {
        HabitFields.id: id,
        HabitFields.title: title,
        HabitFields.inputSingle: inputSingle,
        HabitFields.outputSingle: outputSingle,
        HabitFields.repetitions: repetitions,
        HabitFields.isPaused: isPaused ? 1 : 0,
        HabitFields.createdTime: createdTime.toIso8601String(),
      };

  Habit copy(
          {int? id,
          String? title,
          int? inputSingle,
          int? outputSingle,
          int? repetitions,
          bool? isPaused,
          DateTime? createdTime}) =>
      Habit(
        id: id ?? this.id,
        title: title ?? this.title,
        inputSingle: inputSingle ?? this.inputSingle,
        outputSingle: outputSingle ?? this.outputSingle,
        repetitions: repetitions ?? this.repetitions,
        isPaused: isPaused ?? this.isPaused,
        createdTime: createdTime ?? this.createdTime,
      );

  static Habit fromJson(Map<String, Object?> json) => Habit(
        id: json[HabitFields.id] as int,
        title: json[HabitFields.title] as String,
        inputSingle: json[HabitFields.inputSingle] as int,
        outputSingle: json[HabitFields.outputSingle] as int,
        repetitions: json[HabitFields.repetitions] as int,
        isPaused: json[HabitFields.isPaused] == 1,
        createdTime: DateTime.parse(json[HabitFields.createdTime] as String),
      );
}
