final String habitsTable = 'habits';

class HabitFields {
  static final List<String> values = [ id, title, createdTime];
  static final String id = '_id';
  static final String title = 'title';
  static final String createdTime = 'createdTime';
}

class Habit {
  int? id;
  String title;
  DateTime createdTime;

  Habit({
    this.id,
    required this.title,
    required this.createdTime,
  });

  Map<String, Object?> toJson() =>
      {
        HabitFields.id: id,
        HabitFields.title: title,
        HabitFields.createdTime: createdTime.toIso8601String(),
      };

  Habit copy({
    int? id,
    String? title,
    String? description,
    int? input,
    int? output,
    bool? finished,
    DateTime? createdTime,
    DateTime? finishedTime
  }) =>
      Habit(
          id: id ?? this.id,
          title: title ?? this.title,
          createdTime: createdTime ?? this.createdTime,
      );

  static Habit fromJson(Map<String, Object?> json) => Habit(
    id: json[HabitFields.id] as int,
    title: json[HabitFields.title] as String,
    createdTime: DateTime.parse(json[HabitFields.createdTime] as String),
  );
}
