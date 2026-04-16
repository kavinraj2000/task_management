import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management/app/route_name.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/form/bloc/task_form_bloc.dart';

class TaskFormMobileView extends StatelessWidget {
  const TaskFormMobileView({super.key});

  void _submit(
    BuildContext context,
    bool isEdit,
    GlobalKey<FormBuilderState> formKey,
  ) {
    final valid = formKey.currentState?.saveAndValidate();
    if (valid != true) return;

    final value = formKey.currentState!.value;

    final taskModel = TaskModel(
      id: context.read<TaskFormBloc>().state.initialTask?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: value['title'],
      description: value['description'] ?? '',
      dueDate: value['dueDate'],
      priority: value['priority'],
      status: (value['completed'] ?? false)
          ? TaskStatus.done
          : TaskStatus.pending,
      createdAt: context.read<TaskFormBloc>().state.initialTask?.createdAt ??
          DateTime.now(),
      updatedAt: DateTime.now(),
    );

    context.read<TaskFormBloc>().add(
          SubmitForm(taskdata: taskModel, isEdit: isEdit),
        );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return BlocListener<TaskFormBloc, TaskFormState>(
      listener: (context, state) {
        if (state.formStatus == TaskFormStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task saved successfully')),
          );

          Future.delayed(const Duration(milliseconds: 200), () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteName.taskmanagement);
            }
          });
        }

        if (state.formStatus == TaskFormStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? 'Error occurred')),
          );
        }
      },
      child: BlocBuilder<TaskFormBloc, TaskFormState>(
        builder: (context, state) {
          final initial = state.initialTask;
          final isEdit = initial != null;

          if (state.formStatus == TaskFormStatus.submitting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(isEdit ? "Edit Task" : "Create Task"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: FormBuilder(
              key: formKey,
              initialValue: {
                'title': initial?.title ?? '',
                'description': initial?.description ?? '',
                'dueDate': initial?.dueDate,
                'priority': initial?.priority ?? TaskPriority.low,
                'completed': initial?.status == TaskStatus.done,
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  FormBuilderTextField(
                    name: 'title',
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderTextField(
                    name: 'description',
                    decoration:
                        const InputDecoration(labelText: "Description"),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderDateTimePicker(
                    name: 'dueDate',
                    inputType: InputType.date,
                    decoration:
                        const InputDecoration(labelText: "Due Date"),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderDropdown<TaskPriority>(
                    name: 'priority',
                    items: TaskPriority.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderCheckbox(
                    name: 'completed',
                    title: const Text("Completed"),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.formStatus ==
                              TaskFormStatus.submitting
                          ? null
                          : () => _submit(context, isEdit, formKey),
                      child: Text(isEdit ? "Update" : "Create"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}