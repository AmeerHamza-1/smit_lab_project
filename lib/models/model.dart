class Task {
  String? id;
  String? content;
  bool? completed;
  int? priority;

  Task({
    required this.id,
    required this.content,
    required this.completed,
    required this.priority,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      content: json['content'],
      completed: json['completed'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'completed': completed,
      'priority': priority,
    };
  }
}
