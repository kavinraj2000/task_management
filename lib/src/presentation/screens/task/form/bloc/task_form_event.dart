part of 'task_form_bloc.dart';

abstract class TaskFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFormData extends TaskFormEvent {
  final TaskModel? task;

  LoadFormData(this.task);

 
}

class SubmitForm extends TaskFormEvent {
  final TaskModel taskdata;

  SubmitForm( {required this.taskdata});



 
}
