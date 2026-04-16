import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/task/list/bloc/task_list_bloc.dart';

class FilterChipsWidget extends StatelessWidget {
  const FilterChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListBloc, TaskListState>(
      builder: (context, state) {
        final selected = state.filter.status;

        return SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _chip(context, "All", null, selected),
              _chip(context, "Pending", TaskStatus.pending, selected),
              _chip(context, "Done", TaskStatus.done, selected),
              _chip(context, "Overdue", TaskStatus.overdue, selected),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    TaskStatus? status,
    TaskStatus? selected,
  ) {
    final isSelected = status == selected;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          final bloc = context.read<TaskListBloc>();
          final current = bloc.state.filter;

          bloc.add(
            ApplyFilter(
              current.copyWith(status: status),
            ),
          );
        },
      ),
    );
  }
}