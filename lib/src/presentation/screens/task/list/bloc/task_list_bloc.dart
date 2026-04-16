import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management/src/core/helper/pendig_data.dart';
import 'package:task_management/src/data/model/task_filter.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/repo/task_repo.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskRepository repo;

  TaskListBloc(this.repo) : super(TaskListState.initial()) {
    on<LoadTasks>(_loadTasks);
    on<AddTask>(_addTask);
    on<UpdateTask>(_updateTask);

    on<DeleteTask>(_deleteTask);
    on<UndoDeleteTask>(_undoDelete);
    on<ConfirmDeleteTask>(_confirmDelete);

    on<ApplyFilter>(_applyFilter);
  }

  Future<void> _loadTasks(LoadTasks event, Emitter<TaskListState> emit) async {
    emit(state.copyWith(status: TaskListstatus.loading));

    final tasks = await repo.fetchTasks();

    emit(
      state.copyWith(
        status: TaskListstatus.loaded,
        allTasks: tasks,
        filteredTasks: _applyFilterLogic(tasks, state.filter),
      ),
    );
  }

  Future<void> _addTask(AddTask event, Emitter<TaskListState> emit) async {
    final updated = [...state.allTasks, event.task];

    emit(
      state.copyWith(
        allTasks: updated,
        filteredTasks: _applyFilterLogic(updated, state.filter),
      ),
    );

    await repo.addTask(event.task);
  }

  Future<void> _deleteTask(
    DeleteTask event,
    Emitter<TaskListState> emit,
  ) async {
    final task = state.allTasks.firstWhere((e) => e.id == event.taskId);

    final updatedList = state.allTasks
        .where((e) => e.id != event.taskId)
        .toList();

    state.pendingDeletes[event.taskId]?.timer.cancel();

    final timer = Timer(const Duration(seconds: 5), () {
      add(ConfirmDeleteTask(task.id));
    });

    final newPending = Map<String, PendingDelete>.from(state.pendingDeletes)
      ..[task.id] = PendingDelete(task: task, timer: timer);

    emit(
      state.copyWith(
        allTasks: updatedList,
        filteredTasks: _applyFilterLogic(updatedList, state.filter),
        pendingDeletes: newPending,
      ),
    );
  }

  Future<void> _undoDelete(
    UndoDeleteTask event,
    Emitter<TaskListState> emit,
  ) async {
    final pending = state.pendingDeletes[event.taskId];
    if (pending == null) return;

    pending.timer.cancel();

    final restored = [...state.allTasks, pending.task];

    final updatedPending = Map<String, PendingDelete>.from(state.pendingDeletes)
      ..remove(event.taskId);

    emit(
      state.copyWith(
        allTasks: restored,
        filteredTasks: _applyFilterLogic(restored, state.filter),
        pendingDeletes: updatedPending,
      ),
    );
  }

  Future<void> _confirmDelete(
    ConfirmDeleteTask event,
    Emitter<TaskListState> emit,
  ) async {
    final pending = state.pendingDeletes[event.taskId];
    if (pending == null) return;

    final updatedPending = Map<String, PendingDelete>.from(state.pendingDeletes)
      ..remove(event.taskId);

    emit(state.copyWith(pendingDeletes: updatedPending));

    await repo.deleteTask(event.taskId);
  }

  Future<void> _updateTask(
    UpdateTask event,
    Emitter<TaskListState> emit,
  ) async {
    await repo.updateTask(event.task);

    final updated = state.allTasks.map((t) {
      return t.id == event.task.id ? event.task : t;
    }).toList();

    emit(
      state.copyWith(
        allTasks: updated,
        filteredTasks: _applyFilterLogic(updated, state.filter),
      ),
    );
  }

  void _applyFilter(ApplyFilter event, Emitter<TaskListState> emit) {
    final filtered = _applyFilterLogic(state.allTasks, event.filter);

    emit(state.copyWith(filter: event.filter, filteredTasks: filtered));
  }

  List<TaskModel> _applyFilterLogic(List<TaskModel> tasks, TaskFilter filter) {
    var result = tasks;

    if (filter.search.isNotEmpty) {
      result = result
          .where(
            (e) => e.title.toLowerCase().contains(filter.search.toLowerCase()),
          )
          .toList();
    }

    if (filter.status != null) {
      result = result.where((e) => e.status == filter.status).toList();
    }

    if (filter.priority != null) {
      result = result.where((e) => e.priority == filter.priority).toList();
    }

    return result;
  }
}
