import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/src/presentation/screens/task/list/bloc/task_list_bloc.dart';
import 'package:task_management/src/presentation/screens/task/form/view/mobile/task_form_mobile_view.dart';
import 'package:task_management/src/presentation/screens/task/list/view/mobile/widget/task_tile_widget.dart';

class TaskMobileView extends StatefulWidget {
  const TaskMobileView({super.key});

  @override
  State<TaskMobileView> createState() => _TaskMobileViewState();
}

class _TaskMobileViewState extends State<TaskMobileView> {
  @override
  void initState() {
    super.initState();

    // LOAD TASKS ONCE
    Future.microtask(() {
      context.read<TaskListBloc>().add(LoadTasks());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),

        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskFormMobileView()),
              );
            },
          ),
        ],
      ),

      body: BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          if (state.status == TaskListstatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TaskListstatus.error) {
            return Center(child: Text(state.error ?? "Error"));
          }

          if (state.filteredTasks.isEmpty) {
            return const Center(child: Text("No Tasks"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.filteredTasks.length,
            itemBuilder: (context, index) {
              final task = state.filteredTasks[index];
              return TaskTile(task: task);
            },
          );
        },
      ),
    );
  }
}
