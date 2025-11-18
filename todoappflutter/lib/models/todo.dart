class Todo {
  final String id;
  String title;
  String description;
  bool isCompleted;
  final DateTime createdAt;
  String priority; // High, Medium, Low

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    required this.priority
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todotitle': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'priority': priority,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'] ?? '',
      title: json['todotitle'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      priority: json['priority'] ?? 'medium',
    );
  }
}
