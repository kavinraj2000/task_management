import 'package:sqflite/sqflite.dart';
import 'package:task_management/src/data/database/local_db.dart';
import '../model/task_model.dart';

class LocalDataSource {
  final LocalDb dbProvider;

  LocalDataSource(this.dbProvider);

  Future<Database> get _db async => await dbProvider.database;

  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final db = await _db;

    final batch = db.batch();

    for (final task in tasks) {
      batch.insert(
        'tasks',
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<TaskModel>> getCachedTasks() async {
    final db = await _db;

    final result = await db.query('tasks');

    return result.map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<void> addTask(TaskModel task) async {
    final db = await _db;

    await db.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await _db;

    await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await _db;

    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clear() async {
    final db = await _db;
    await db.delete('tasks');
  }
}
