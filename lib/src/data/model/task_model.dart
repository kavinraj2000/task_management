import 'package:equatable/equatable.dart';

enum TaskStatus { pending, inProgress, done }

enum TaskPriority { low, medium, high }

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  // ---------------------------
  // COPY WITH
  // ---------------------------
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }


  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: (json['id'] ?? '').toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',

      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now(),

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),

      status: _parseStatus(json['status']),
      priority: _parsePriority(json['priority']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'priority': priority.name,
    };
  }

  static TaskStatus _parseStatus(String? value) {
    switch (value) {
      case 'inProgress':
        return TaskStatus.inProgress;
      case 'done':
        return TaskStatus.done;
      default:
        return TaskStatus.pending;
    }
  }

  static TaskPriority _parsePriority(String? value) {
    switch (value) {
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      default:
        return TaskPriority.low;
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    dueDate,
    status,
    priority,
    createdAt,
  ];

  factory TaskModel.fromForm(Map<String, dynamic> value) {
    final isDone = value['completed'] ?? false;

    return TaskModel(
      id: value['id'].toString(),
      title: value['title'],
      description: value['description'] ?? '',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now(),
      status: isDone ? TaskStatus.done : TaskStatus.pending,
      priority: TaskPriority.medium,
    );
  }
}
