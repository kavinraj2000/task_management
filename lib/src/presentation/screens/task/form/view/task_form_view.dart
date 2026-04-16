import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/form/bloc/task_form_bloc.dart';
import 'package:task_management/src/presentation/screens/task/form/view/mobile/task_form_mobile_view.dart';
import 'package:task_management/src/presentation/screens/task/repo/task_repo.dart';

class TaskFormView extends StatelessWidget {
  final TaskRepository repository;
  final TaskModel? task;

  const TaskFormView({
    super.key,
    required this.repository,
    this.task,
  });

  static final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    _logger.d("TaskFormView task: $task");

    return BlocProvider(
      create: (_) => TaskFormBloc(
        repo: repository,
        task: task, // ✅ passed safely into Bloc
      ),
      child:  TaskFormMobileView(),
    );
  }
}