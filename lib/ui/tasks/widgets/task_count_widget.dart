import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_count_notifier.dart';

class TaskCountWidget extends ConsumerWidget {
  const TaskCountWidget(this.text, {this.isDone = false, super.key});

  final String text;
  final bool isDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerConfigProvider);
    final collection = router.state.pathParameters['id'];

    final taskCount = ref.watch(
      taskCountNotifierProvider(
        title: text,
        collection: collection,
        isDone: isDone,
      ),
    );

    return switch (taskCount) {
      AsyncLoading() => Skeletonizer(child: Text(text)),
      AsyncData(:final value) => Text('$text - $value'),
      _ => Text(text),
    };
  }
}
