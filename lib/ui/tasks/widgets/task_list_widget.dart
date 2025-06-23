import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/constants/fake_models.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/tasks/providers/filtered_tasks.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_count_widget.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_tile.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 48,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _UndoneTasks(key: Key('UndoneTasksList')),
        _DoneTasks(key: Key('DoneTasksList')),
      ],
    );
  }
}

class _UndoneTasks extends ConsumerWidget {
  const _UndoneTasks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerConfigProvider);
    final collectionId = router.state.pathParameters['id'];
    final undoneTasks = ref.watch(filteredTasksProvider(collectionId, false));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        const TaskCountWidget('Tasks'),
        switch (undoneTasks) {
          AsyncLoading() => _TaskListBuilder(fakeTasks, isLoading: true),
          AsyncData(:final value) => _TaskListBuilder(value),
          AsyncError(:final error) => Text(error.toString()),
          _ => const SizedBox.shrink(),
        },
      ],
    );
  }
}

class _DoneTasks extends ConsumerWidget {
  const _DoneTasks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerConfigProvider);
    final collectionId = router.state.pathParameters['id'];
    final doneTasks = ref.watch(filteredTasksProvider(collectionId, true));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        const TaskCountWidget('Completed', isDone: true),
        switch (doneTasks) {
          AsyncLoading() => _TaskListBuilder(fakeTasks, isLoading: true),
          AsyncData(:final value) => _TaskListBuilder(value),
          AsyncError(:final error) => Text(error.toString()),
          _ => const SizedBox.shrink(),
        },
      ],
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
