class TaskModel {
  final String id;
  String title;
  String note;
  bool isCompleted;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    this.note = '',
    this.isCompleted = false,
    required this.createdAt,
  });

  TaskModel copyWith({
    String? title,
    String? note,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        title: json['title'],
        note: json['note'] ?? '',
        isCompleted: json['isCompleted'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
      );
}
