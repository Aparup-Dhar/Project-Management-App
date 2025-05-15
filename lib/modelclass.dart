class Project {
  String id;
  String name;

  Project({required this.id, required this.name});

  Map<String, dynamic> toJson() => {"id": id, "name": name};

  factory Project.fromJson(Map<String, dynamic> json) =>
      Project(id: json['id'], name: json['name']);
}

class Task {
  String id;
  String name;

  Task({required this.id, required this.name});

  Map<String, dynamic> toJson() => {"id": id, "name": name};

  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(id: json['id'], name: json['name']);
}

class TimerEntry {
  String id;
  String projectId;
  String taskId;
  String date;
  double totalTime;
  String note;

  TimerEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.date,
    required this.totalTime,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "projectId": projectId,
    "taskId": taskId,
    "date": date,
    "totalTime": totalTime,
    "note": note
  };

  factory TimerEntry.fromJson(Map<String, dynamic> json) => TimerEntry(
      id: json['id'],
      projectId: json['projectId'],
      taskId: json['taskId'],
      date: json['date'],
      totalTime: json['totalTime'],
      note: json['note']);
}
