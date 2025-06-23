import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/ui/tasks/providers/tasks_notifier.dart';

part 'filtered_tasks.g.dart';

@riverpod
/// Listens to the main [TasksNotifier] and its provider -
/// [tasksNotifierProvider] and filters the result based on the [isDone] value
/// provided by the user.ref
///
/// To get undone tasks, set the [isDone] value to `false`.
///
/// To get done tasks, set the [isDone] value to `true`.
///
FutureOr<List<Task?>> filteredTasks(
  Ref ref,
  String? collectionId,
  bool isDone,
) {
  // If collectionId is null, immediately return an empty stream.
  if (collectionId == null) return [];

  final tasks = ref.watch(tasksNotifierProvider(collectionId)).valueOrNull;
  if (tasks == null || tasks.isEmpty) return [];

  // Filter the tasks
  final filteredTasks = tasks
      .where((task) => task != null && task.isDone == isDone)
      .toList();

  return filteredTasks;
}
