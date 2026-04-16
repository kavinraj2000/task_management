import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/repo/task_repo.dart';

part 'task_form_event.dart';
part 'task_form_state.dart';

class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState> {
  final TaskRepository repo;

  TaskFormBloc(this.repo) : super(TaskFormState.initial()) {

    on<LoadFormData>(_onLoadFormData);

    on<SubmitForm>(_onSubmitForm);
  }

  Future<void> _onLoadFormData(
    LoadFormData event,
    Emitter<TaskFormState> emit,
  ) async {
    final task = event.task;

    emit(state.copyWith(
      id: task?.id,
      title: task?.title,
      description: task?.description,
      status: task?.status,
      priority: task?.priority,
    ));
  }

  Future<void> _onSubmitForm(
    SubmitForm event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(state.copyWith(formStatus: TaskFormStatus.submitting));

    try {
      final task = TaskModel(
        id: event.taskdata.id ,
        title: event.taskdata.title,
        description: event.taskdata.description ?? '',
        dueDate: event.taskdata.dueDate ?? DateTime.now(),
        createdAt: DateTime.now(),
        status: event.taskdata.status,
        priority: event.taskdata.priority,
      );

      // if (event.isEdit) {
      //   await repo.updateTask(task);
      // } else {
      //   await repo.addTask(task);
      // }

      emit(state.copyWith(formStatus: TaskFormStatus.success));

    } catch (e) {
      emit(state.copyWith(
        formStatus: TaskFormStatus.error,
        error: e.toString(),
      ));
    }
  }
}