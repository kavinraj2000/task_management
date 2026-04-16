part of 'task_list_bloc.dart';

enum TaskListstatus { initial, loading, loaded, error }

class TaskListState extends Equatable {
  final List<TaskModel> allTasks;
  final List<TaskModel> filteredTasks;
  final TaskFilter filter;
  final Map<String, PendingDelete> pendingDeletes;
  final TaskListstatus status;
  final String? error;

  const TaskListState({
    this.allTasks = const [],
    this.filteredTasks = const [],
    this.filter = const TaskFilter(),
    this.pendingDeletes = const {},
    this.status = TaskListstatus.initial,
    this.error,
  });

  factory TaskListState.initial(){
    return TaskListState(status: TaskListstatus.initial);
  }

  TaskListState copyWith({
    List<TaskModel>? allTasks,
    List<TaskModel>? filteredTasks,
    TaskFilter? filter,
    Map<String, PendingDelete>? pendingDeletes,
    TaskListstatus? status,
    String? error,
  }) {
    return TaskListState(
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      filter: filter ?? this.filter,
      pendingDeletes: pendingDeletes ?? this.pendingDeletes,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        allTasks,
        filteredTasks,
        filter,
        pendingDeletes,
        status,
        error,
      ];
}