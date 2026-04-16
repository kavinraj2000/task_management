import 'package:equatable/equatable.dart';
import 'package:task_management/src/data/model/task_model.dart';

enum TaskSortBy { dueDate, priority, createdAt }

class TaskFilter extends Equatable {
  final TaskStatus? status;
  final TaskPriority? priority;
  final TaskSortBy sortBy;
  final String search;

  const TaskFilter({
    this.status,
    this.priority,
    this.sortBy = TaskSortBy.createdAt,
    this.search = '',
  });

  TaskFilter copyWith({
    TaskStatus? status,
    TaskPriority? priority,
    TaskSortBy? sortBy,
    String? search,
  }) {
    return TaskFilter(
      status: status ?? this.status,
      priority: priority ?? this.priority,
      sortBy: sortBy ?? this.sortBy,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [status, priority, sortBy, search];
}