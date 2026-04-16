import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/form/bloc/task_form_bloc.dart';
import 'package:task_management/src/presentation/screens/task/list/bloc/task_list_bloc.dart';

class TaskFormMobileView extends StatelessWidget {
  TaskFormMobileView({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Form")),

      body: BlocListener<TaskFormBloc, TaskFormState>(
        listener: (context, state) {
          if (state.formStatus == TaskFormStatus.success) {
            /// 🔥 refresh list after success
            context.read<TaskListBloc>().add(LoadTasks());

            Navigator.pop(context);
          }

          if (state.formStatus == TaskFormStatus.error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error ?? "Error")));
          }
        },

        child: Padding(
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

                FormBuilderTextField(
                  name: 'description',
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                FormBuilderCheckbox(
                  name: 'completed',
                  title: const Text("Mark as Done"),
                  initialValue: false,
                ),

                const SizedBox(height: 20),

                BlocBuilder<TaskFormBloc, TaskFormState>(
                  builder: (context, state) {
                    final isLoading =
                        state.formStatus == TaskFormStatus.submitting;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                final isValid = _formKey.currentState
                                    ?.saveAndValidate();

                                if (isValid != true) return;

                                final value = _formKey.currentState!.value;

                                final bool isDone = value['completed'] ?? false;

                                final task = TaskModel(
                                  id: value['id'].toString(),
                                  title: value['title'],
                                  description: value['description'] ?? '',
                                  dueDate: DateTime.now().add(
                                    const Duration(days: 1),
                                  ),
                                  createdAt: DateTime.now(),
                                  status: isDone
                                      ? TaskStatus.done
                                      : TaskStatus.pending,
                                  priority: TaskPriority.medium,
                                );

                                context.read<TaskFormBloc>().add(
                                  SubmitForm(taskdata: task),
                                );
                              },
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Submit"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
