import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:task_management/app/route_name.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/list/bloc/task_list_bloc.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({super.key, required this.task});

  Color _statusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.done:
        return Colors.green;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.overdue:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  tooltip: "Edit Task",
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    context.pushNamed(RouteName.addtask, extra: task);
                  },
                ),

                IconButton(
                  tooltip: "Delete Task",
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _handleDelete(context),
                ),
              ],
            ),

            const SizedBox(height: 6),

            if (task.description.isNotEmpty)
              Text(
                task.description,
                style: const TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(task.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.status.name.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _priorityColor(task.priority),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.priority.name.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),

                Text(
                  "Due: ${task.dueDate.toLocal().toString().split(' ')[0]}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    final bloc = context.read<TaskListBloc>();

    if (bloc.state.pendingDeletes.containsKey(task.id)) return;

    bloc.add(DeleteTask(task.id));

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text("Task deleted"),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: "UNDO",
            onPressed: () {
              bloc.add(UndoDeleteTask(task.id));
            },
          ),
        ),
      );
  }
}
