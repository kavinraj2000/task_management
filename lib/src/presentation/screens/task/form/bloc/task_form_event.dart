part of 'task_form_bloc.dart';

abstract class TaskFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialFormData extends TaskFormEvent {
  final TaskModel? task;

  InitialFormData(this.task);

  @override
  List<Object?> get props => [task];
}

class SubmitForm extends TaskFormEvent {
  final TaskModel taskdata;
  final bool isEdit;

  SubmitForm({required this.taskdata, this.isEdit = false});
}
