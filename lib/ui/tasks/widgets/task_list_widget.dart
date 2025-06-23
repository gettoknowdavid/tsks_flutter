import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/constants/fake_models.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_error_widget.dart';
import 'package:tsks_flutter/ui/tasks/providers/filtered_tasks.dart';
import 'package:tsks_flutter/ui/tasks/providers/tasks_notifier.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_tile.dart';

class TaskListWidget extends ConsumerWidget {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerConfigProvider);
    final collectionId = router.state.pathParameters['id'];
    final tasksAsync = ref.watch(tasksNotifierProvider(collectionId));

    return tasksAsync.when(
      error: (error, _) => TsksErrorWidget(error),
      loading: () => _TaskListBuilder(fakeTasks, isLoading: true),
      data: (allTasks) {
        if (allTasks.isEmpty) return const SizedBox();
        return Column(
          spacing: 48,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FilteredTasksWidget(
              key: const Key('UndoneTasksList'),
              title: 'Tasks',
              collection: collectionId,
              isDone: false,
            ),
            _FilteredTasksWidget(
              key: const Key('DoneTasksList'),
              title: 'Completed',
              collection: collectionId,
              isDone: true,
            ),
          ],
        );
      },
    );
  }
}

class _FilteredTasksWidget extends ConsumerWidget {
  const _FilteredTasksWidget({
    required this.title,
    required this.collection,
    required this.isDone,
    super.key,
  });

  final String title;
  final String? collection;
  final bool isDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTasks = ref.watch(filteredTasksProvider(collection, isDone));

    return filteredTasks.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (tasks) {
        if (tasks.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Text('$title - ${tasks.length}'),
            _TaskListBuilder(tasks),
          ],
        );
      },
    );
  }
}

class _TaskListBuilder extends StatelessWidget {
  const _TaskListBuilder(this.tasks, {this.isLoading = false});

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
        separatorBuilder: (context, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) => TaskTile(
          key: ValueKey<String>(tasks[index]!.id),
          task: tasks[index]!,
        ),
      ),
    );
  }
}
