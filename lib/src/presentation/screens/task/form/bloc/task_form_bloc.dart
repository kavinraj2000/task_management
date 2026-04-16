import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/repo/task_repo.dart';

part 'task_form_event.dart';
part 'task_form_state.dart';

class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState> {
  final TaskRepository repo;

  TaskFormBloc({
    required this.repo,
    TaskModel? task,
  }) : super(TaskFormState.initial()) {
    on<InitialFormData>(_onLoadInitialFormData);
    on<SubmitForm>(_onSubmitForm);

    if (task != null) {
      add(InitialFormData(task));
    }
  }

  Future<void> _onLoadInitialFormData(
    InitialFormData event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(state.copyWith(initialTask: event.task));
  }

  Future<void> _onSubmitForm(
    SubmitForm event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(state.copyWith(formStatus: TaskFormStatus.submitting));

    try {
      final now = DateTime.now();

      final task = event.taskdata.copyWith(
        createdAt: event.isEdit ? event.taskdata.createdAt : now,
        updatedAt: now,
      );

      if (event.isEdit) {
        await repo.updateTask(task);
      } else {
        await repo.addTask(task);
      }

      emit(state.copyWith(formStatus: TaskFormStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          formStatus: TaskFormStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}