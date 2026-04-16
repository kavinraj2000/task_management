import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/list/bloc/task_list_bloc.dart';

class TaskFormScreen extends StatelessWidget {
  TaskFormScreen({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Form")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'id',
                decoration: const InputDecoration(
                  labelText: "Task ID",
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
              ),

              const SizedBox(height: 12),

              FormBuilderTextField(
                name: 'title',
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
              ),

              const SizedBox(height: 12),

              /// DESCRIPTION
              FormBuilderTextField(
                name: 'description',
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              /// COMPLETED → STATUS
              FormBuilderCheckbox(
                name: 'completed',
                title: const Text("Mark as Done"),
                initialValue: false,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState?.saveAndValidate();

                    if (isValid != true) return;

                    final value = _formKey.currentState!.value;

                    final bool isDone = value['completed'] ?? false;

                    final task = TaskModel(
                      id: value['id'].toString(),
                      title: value['title'],
                      description: value['description'] ?? '',
                      dueDate: DateTime.now().add(const Duration(days: 1)),
                      createdAt: DateTime.now(),
                      status: isDone ? TaskStatus.done : TaskStatus.pending,
                      priority: TaskPriority.medium,
                    );

                    context.read<TaskListBloc>().add(AddTask(task));

                    Navigator.pop(context);
                  },
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
