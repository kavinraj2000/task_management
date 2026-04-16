import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_management/src/presentation/screens/task/list/bloc/task_list_bloc.dart';
import 'package:task_management/src/presentation/screens/task/repo/task_repo.dart';
import 'package:task_management/src/presentation/screens/task/list/view/mobile/task_list_mobile_view.dart';

class TaskListView extends StatelessWidget {
  final TaskRepository repository;

  const TaskListView({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskListBloc(repository)..add(LoadTasks()),
      child: const TaskMobileView(),
    );
  }
}
