final String weeksTable = 'weeks';

class WeekFields {
  static final List<String> values = [ id, index, startTime, endTime];
  static final String id = '_id';
  static final String index = 'index';
  static final String startTime = 'startTime';
  static final String endTime = 'endTime';
}

class Week {
  int? id;
  int index;
  DateTime startTime;
  DateTime endTime;

  Week({
    this.id,
    required this.index,
    required this.startTime,
    required this.endTime,
  });

  Map<String, Object?> toJson() =>
      {
        WeekFields.id: id,
        WeekFields.index: index,
        WeekFields.startTime: startTime.toIso8601String(),
        WeekFields.endTime: endTime.toIso8601String(),
      };

  Week copy({
    int? id,
    int? index,
    DateTime? startTime,
    DateTime? endTime,
  }) =>
      Week(
        id: id ?? this.id,
        index: index ?? this.index,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
      );

  static Week fromJson(Map<String, Object?> json) => Week(
    id: json[WeekFields.id] as int,
    index: json[WeekFields.index] as int,
    startTime: DateTime.parse(json[WeekFields.startTime] as String),
    endTime: DateTime.parse(json[WeekFields.endTime] as String),
  );
}
