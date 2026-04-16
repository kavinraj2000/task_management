import 'package:task_management/src/data/model/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> fetchTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}
