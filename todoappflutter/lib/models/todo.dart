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
    try {
      return Todo(
        id: json['_id']?.toString() ?? '',
        title: json['todotitle']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        isCompleted: json['isCompleted'] == true,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'].toString())
            : DateTime.now(),
        priority: json['priority']?.toString() ?? 'medium',
      );
    } catch (e) {
      print('Error parsing Todo from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}
