final String goalsTable = 'goals';

class GoalFields {
  static final List<String> values = [ id, title, isFinished, createdTime];
  static final String id = '_id';
  static final String title = 'title';
  static final String isFinished = 'isFinished';
  static final String createdTime = 'createdTime';
}

class Goal {
  int? id;
  String title;
  bool isFinished;
  DateTime createdTime;

  Goal({
    this.id,
    required this.title,
    required this.isFinished,
    required this.createdTime,
  });

  Map<String, Object?> toJson() =>
      {
        GoalFields.id: id,
        GoalFields.title: title,
        GoalFields.isFinished: isFinished ? 1 : 0,
        GoalFields.createdTime: createdTime.toIso8601String(),
      };

  Goal copy({
    int? id,
    String? title,
    bool? isFinished,
    DateTime? createdTime,
  }) =>
      Goal(
        id: id ?? this.id,
        title: title ?? this.title,
        isFinished: isFinished ?? this.isFinished,
        createdTime: createdTime ?? this.createdTime,
      );

  static Goal fromJson(Map<String, Object?> json) => Goal(
    id: json[GoalFields.id] as int,
    title: json[GoalFields.title] as String,
    isFinished: json[GoalFields.isFinished] == 1,
    createdTime: DateTime.parse(json[GoalFields.createdTime] as String),
  );
}
