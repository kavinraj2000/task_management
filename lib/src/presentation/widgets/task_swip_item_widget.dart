import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/list/bloc/task_list_bloc.dart';
import 'package:task_management/src/presentation/widgets/task_tile_widget.dart';

class TaskSwipeItem extends StatelessWidget {
  final TaskModel task;

  const TaskSwipeItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),

      direction: DismissDirection.endToStart,

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      onDismissed: (_) {
        context.read<TaskListBloc>().add(DeleteTask(task.id));

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Task deleted"),
              action: SnackBarAction(
                label: "UNDO",
                onPressed: () {
                  context.read<TaskListBloc>().add(UndoDeleteTask(task.id));
                },
              ),
            ),
          );
        });
      },

      child: TaskTile(task: task),
    );
  }
}
