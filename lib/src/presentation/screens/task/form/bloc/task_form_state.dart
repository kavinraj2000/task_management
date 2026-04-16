part of 'task_form_bloc.dart';

enum TaskFormStatus { initial,loading, submitting, success, error }

class TaskFormState extends Equatable {
  final TaskFormStatus formStatus;
  final String? error;
  final TaskModel? initialTask;
  final bool loaded;

  const TaskFormState({
    required this.formStatus,
    this.error,
    this.initialTask,
    this.loaded = false,
  });

  factory TaskFormState.initial() {
    return const TaskFormState(
      formStatus: TaskFormStatus.initial,
      loaded: false,
    );
  }

  TaskFormState copyWith({
    TaskFormStatus? formStatus,
    String? error,
    TaskModel? initialTask,
    bool? loaded,
  }) {
    return TaskFormState(
      formStatus: formStatus ?? this.formStatus,
      error: error,
      initialTask: initialTask ?? this.initialTask,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object?> get props => [formStatus, error, initialTask, loaded];
}