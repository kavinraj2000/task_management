import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/form/bloc/task_form_bloc.dart';
import 'package:task_management/src/presentation/screens/task/form/view/mobile/task_form_mobile_view.dart';
import 'package:task_management/src/presentation/screens/task/repo/task_repo.dart';

class TaskFormView extends StatelessWidget {
  final TaskRepository repository;
  final TaskModel? task;

  const TaskFormView({super.key, required this.repository, this.task});


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => TaskFormBloc(repo: repository, task: task),
      child: TaskFormMobileView(),
    );
  }
}
