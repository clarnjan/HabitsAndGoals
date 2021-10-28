import 'package:diplomska1/Classes/Tables/WeeklyHabit.dart';
import 'package:diplomska1/Classes/Tables/WeeklyTask.dart';

//Име на табелата
final String weeksTable = 'weeks';

//Помошна класа со статични променливи за имињата на колоните
class WeekFields {
  static final List<String> values = [id, title, startDate, endDate];
  static final String id = '_id';
  static final String title = 'title';
  static final String startDate = 'startDate';
  static final String endDate = 'endDate';
}

//Класа која ја претставува табелата Weeks
class Week {
  int? id;
  String title;
  DateTime startDate;
  DateTime endDate;
  late List<WeeklyHabit> habits;
  late List<WeeklyTask> tasks;

  Week({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.habits = const [],
    this.tasks = const [],
  });

  Map<String, Object?> toJson() => {
        WeekFields.id: id,
        WeekFields.title: title,
        WeekFields.startDate: startDate.toIso8601String(),
        WeekFields.endDate: endDate.toIso8601String(),
      };

  Week copy({
    int? id,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
  }) =>
      Week(
        id: id ?? this.id,
        title: title ?? this.title,
        startDate: startTime ?? this.startDate,
        endDate: endTime ?? this.endDate,
      );

  static Week fromJson(Map<String, Object?> json) => Week(
        id: json[WeekFields.id] as int,
        title: json[WeekFields.title] as String,
        startDate: DateTime.parse(json[WeekFields.startDate] as String),
        endDate: DateTime.parse(json[WeekFields.endDate] as String),
      );
}
