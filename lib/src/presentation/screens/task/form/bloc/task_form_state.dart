part of 'task_form_bloc.dart';


enum TaskFormStatus { initial, submitting, success, error }

class TaskFormState extends Equatable {
  final String? id;
  final String? title;
  final String? description;

  final TaskStatus status;
  final TaskPriority priority;

  final bool completed;

  final TaskFormStatus formStatus;
  final String? error;

  const TaskFormState({
    this.id,
    this.title,
    this.description,
    this.status = TaskStatus.pending,
    this.priority = TaskPriority.medium,
    this.completed = false,
    this.formStatus = TaskFormStatus.initial,
    this.error,
  });

  factory TaskFormState.initial() {
    return const TaskFormState();
  }

  TaskFormState copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    bool? completed,
    TaskFormStatus? formStatus,
    String? error,
  }) {
    return TaskFormState(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      formStatus: formStatus ?? this.formStatus,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        priority,
        completed,
        formStatus,
        error,
      ];
}