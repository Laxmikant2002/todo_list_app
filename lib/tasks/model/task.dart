class Task {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    this.dueDate,
  });

  factory Task.fromJson(String id, Map<String, dynamic> json) {
    return Task(
      id: id,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
