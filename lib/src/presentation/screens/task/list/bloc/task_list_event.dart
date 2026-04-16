part of 'task_list_bloc.dart';

abstract class TaskListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskListEvent {}

class AddTask extends TaskListEvent {
  final TaskModel task;
  AddTask(this.task);
}

class UpdateTask extends TaskListEvent {
  final TaskModel task;
  UpdateTask(this.task);
}

class DeleteTask extends TaskListEvent {
  final String taskId;
  DeleteTask(this.taskId);
}

class UndoDeleteTask extends TaskListEvent {
  final String taskId;
  UndoDeleteTask(this.taskId);
}

class ApplyFilter extends TaskListEvent {
  final TaskFilter filter;
  ApplyFilter(this.filter);
}

class SearchTasks extends TaskListEvent {
  final String query;
  SearchTasks(this.query);
}