import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/list/bloc/task_list_bloc.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),

        trailing: PopupMenuButton(
          itemBuilder: (_) => [
            PopupMenuItem(
              child: const Text("Delete"),
              onTap: () {
                context.read<TaskListBloc>().add(DeleteTask(task.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}
