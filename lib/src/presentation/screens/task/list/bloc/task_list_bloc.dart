import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management/src/core/util/pendig_data.dart';
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
    on<ApplyFilter>(_applyFilter);
  }
  Future<void> _loadTasks(LoadTasks event, Emitter<TaskListState> emit) async {
    emit(state.copyWith(status: TaskListstatus.loading));

    try {
      final tasks = await repo.fetchTasks();

      emit(
        state.copyWith(
          status: TaskListstatus.loaded,
          allTasks: tasks,
          filteredTasks: _applyFilterLogic(tasks, state.filter),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TaskListstatus.error, error: e.toString()));
    }
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

  Future<void> _deleteTask(DeleteTask event, Emitter<TaskListState> emit) async {
    final task = state.allTasks.firstWhere((e) => e.id == event.taskId);

    final updated = state.allTasks.where((e) => e.id != event.taskId).toList();

    final timer = Timer(const Duration(seconds: 5), () {
      add(UndoDeleteTask(task.id));
    });

    final pending = Map<String, PendingDelete>.from(state.pendingDeletes)
      ..[task.id] = PendingDelete(task: task, timer: timer);

    emit(
      state.copyWith(
        allTasks: updated,
        filteredTasks: _applyFilterLogic(updated, state.filter),
        pendingDeletes: pending,
      ),
    );
  }

  Future<void> _updateTask(UpdateTask event, Emitter<TaskListState> emit) async {
    try {
      emit(state.copyWith(status: TaskListstatus.loading, error: null));

      await repo.updateTask(event.task);

      final updatedTasks = state.allTasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();

      final updatedFiltered = _applyFilterLogic(updatedTasks, state.filter);

      emit(
        state.copyWith(
          status: TaskListstatus.loaded,
          allTasks: updatedTasks,
          filteredTasks: updatedFiltered,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TaskListstatus.error, error: e.toString()));
    }
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

  void _applyFilter(ApplyFilter event, Emitter<TaskListState> emit) {
    final filter = event.filter;

    final filtered = _applyFilterLogic(state.allTasks, filter);

    emit(
      state.copyWith(
        filter: filter,
        filteredTasks: filtered,
        status: TaskListstatus.loaded,
      ),
    );
  }

  List<TaskModel> _applyFilterLogic(List<TaskModel> tasks, TaskFilter filter) {
    var result = tasks;

    if (filter.status != null) {
      result = result.where((e) => e.status == filter.status).toList();
    }

    if (filter.priority != null) {
      result = result.where((e) => e.priority == filter.priority).toList();
    }

    if (filter.search.isNotEmpty) {
      result = result
          .where(
            (e) => e.title.toLowerCase().contains(filter.search.toLowerCase()),
          )
          .toList();
    }

    result.sort((a, b) {
      switch (filter.sortBy) {
        case TaskSortBy.dueDate:
          return a.dueDate.compareTo(b.dueDate);
        case TaskSortBy.priority:
          return a.priority.index.compareTo(b.priority.index);
        case TaskSortBy.createdAt:
          return b.createdAt.compareTo(a.createdAt);
      }
    });

    return result;
  }
}
