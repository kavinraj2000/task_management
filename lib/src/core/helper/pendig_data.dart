import 'dart:async';

import 'package:task_management/src/data/model/task_model.dart';

class PendingDelete {
  final TaskModel task;
  final Timer timer;

  const PendingDelete({
    required this.task,
    required this.timer,
  });
}