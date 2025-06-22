import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/constants/fake_models.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/ui/tasks/providers/sub_tasks_notifier.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_tile.dart';

class SubTaskListWidget extends ConsumerWidget {
  const SubTaskListWidget({
    required this.collection,
    required this.parentTask,
    super.key,
  });

  final String collection;
  final String parentTask;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subTasks = ref.watch(
      subTasksNotifierProvider(collection: collection, parentTask: parentTask),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: switch (subTasks) {
        AsyncLoading() => TaskListBuilder(fakeTasks, isLoading: true),
        AsyncData(:final value) => TaskListBuilder(value),
        AsyncError(:final error) => Text(error.toString()),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class TaskListBuilder extends StatelessWidget {
  const TaskListBuilder(this.tasks, {this.isLoading = false, super.key});

  final List<Task?> tasks;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        separatorBuilder: (context, _) => const SizedBox(height: 6),
        itemBuilder: (context, index) => TaskTile(
          key: ValueKey<String>(tasks[index]!.id),
          task: tasks[index]!,
        ),
      ),
    );
  }
}
