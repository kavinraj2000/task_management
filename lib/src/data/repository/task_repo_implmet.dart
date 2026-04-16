import 'package:dio/dio.dart';
import 'package:task_management/src/data/database/local_datasource.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/data/repository/task_api_repo.dart';
import 'package:task_management/src/presentation/screens/task/repo/task_repo.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Dio dio;
  final LocalDataSource local;
  final baseapi = TaskApiRepo.api;

  TaskRepositoryImpl({required this.dio, required this.local});

  @override
  Future<List<TaskModel>> fetchTasks() async {
    try {
      final res = await dio.get(baseapi);

      final tasks = (res.data as List)
          .map((e) => TaskModel.fromJson(e))
          .toList();

      await local.cacheTasks(tasks);
      return tasks;
    } catch (_) {
      return local.getCachedTasks();
    }
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await dio.post(baseapi, data: task.toJson());
    await local.addTask(task);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await dio.put("$baseapi/${task.id}", data: task.toJson());
    await local.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await dio.delete("$baseapi/$id");
    await local.deleteTask(id);
  }
}
