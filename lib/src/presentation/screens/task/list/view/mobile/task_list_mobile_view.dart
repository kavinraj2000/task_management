import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management/app/route_name.dart';
import 'package:task_management/src/core/services/service_locator.dart';
import 'package:task_management/src/presentation/screens/auth/controller/auth_controller.dart';
import 'package:task_management/src/presentation/screens/task/list/bloc/task_list_bloc.dart';
import 'package:task_management/src/presentation/widgets/empty_state.dart';
import 'package:task_management/src/presentation/widgets/filter_chip_widget.dart';
import 'package:task_management/src/presentation/widgets/task_swip_item_widget.dart';

class TaskMobileView extends StatelessWidget {
  const TaskMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskListBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.pushNamed(RouteName.addtask),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final controller = getIt<AuthController>();
              controller.logout();
              context.go(RouteName.login);
            },
          ),
        ],
      ),

      body: BlocListener<TaskListBloc, TaskListState>(
        listenWhen: (prev, curr) =>
            prev.pendingDeletes.length != curr.pendingDeletes.length,

        listener: (context, state) {},

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  final current = bloc.state.filter;
                  bloc.add(ApplyFilter(current.copyWith(search: value)));
                },
              ),
            ),

            const FilterChipsWidget(),

            Expanded(
              child: BlocBuilder<TaskListBloc, TaskListState>(
                builder: (context, state) {
                  if (state.status == TaskListstatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == TaskListstatus.error) {
                    return Center(child: Text(state.error ?? "Error"));
                  }

                  if (state.filteredTasks.isEmpty) {
                    return const EmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = state.filteredTasks[index];

                      return TaskSwipeItem(task: task);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
