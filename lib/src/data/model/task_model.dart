import 'package:equatable/equatable.dart';

enum TaskStatus { pending, inProgress, done, overdue }

enum TaskPriority { low, medium, high }

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory TaskModel.fromApi(Map<String, dynamic> json) {
    final completed = json['completed'] ?? false;

    return TaskModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: '',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: completed ? TaskStatus.done : TaskStatus.pending,
      priority: TaskPriority.low,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final due = json['dueDate'] != null
        ? DateTime.parse(json['dueDate'])
        : DateTime.now();

    final parsedStatus = _parseStatus(json['status']);

    final finalStatus =
        (parsedStatus == TaskStatus.pending && due.isBefore(DateTime.now()))
        ? TaskStatus.overdue
        : parsedStatus;

    return TaskModel(
      id: (json['id'] ?? '').toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: due,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      status: finalStatus,
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
      'updatedAt': updatedAt.toIso8601String(),
      'status': status.name,
      'priority': priority.name,
    };
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'status': status.name,
      'priority': priority.name,
    };
  }

  factory TaskModel.fromDb(Map<String, dynamic> map) {
    final due = DateTime.fromMillisecondsSinceEpoch(map['dueDate']);

    final parsedStatus = _parseStatus(map['status']);

    final finalStatus =
        (parsedStatus == TaskStatus.pending && due.isBefore(DateTime.now()))
        ? TaskStatus.overdue
        : parsedStatus;

    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: due,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : DateTime.now(),
      status: finalStatus,
      priority: _parsePriority(map['priority']),
    );
  }

  factory TaskModel.fromForm(Map<String, dynamic> value) {
    final isDone = value['completed'] ?? false;

    return TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: value['title'] ?? '',
      description: value['description'] ?? '',
      dueDate: value['dueDate'] ?? DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: isDone ? TaskStatus.done : TaskStatus.pending,
      priority: value['priority'] ?? TaskPriority.medium,
    );
  }

  bool get isOverdue =>
      status == TaskStatus.overdue ||
      (status == TaskStatus.pending && dueDate.isBefore(DateTime.now()));

  static TaskStatus _parseStatus(String? value) {
    switch (value) {
      case 'inProgress':
        return TaskStatus.inProgress;
      case 'done':
        return TaskStatus.done;
      case 'overdue':
        return TaskStatus.overdue;
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
    updatedAt,
  ];
}
