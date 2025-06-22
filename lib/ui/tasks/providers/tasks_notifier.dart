import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/data/repositories/tasks/tasks_repository.dart';
import 'package:tsks_flutter/models/tasks/task.dart';

part 'tasks_notifier.g.dart';

@riverpod
class TasksNotifier extends _$TasksNotifier {
  @override
  FutureOr<List<Task?>> build(String? collection, {bool? isDone}) async {
    if (collection == null) throw const NoCollectionFoundException();
    final repository = ref.read(tasksRepositoryProvider);
    final res = await repository.getTopLevelTasks(collection);
    return res.fold((exception) => throw exception, (tasks) {
      if (isDone == null) return tasks;
      return tasks.where((t) => t?.isDone == isDone).toList();
    });
  }

  void optimisticallyUpdate(Task task) {
    state.whenData((tasks) {
      if (tasks.isEmpty) {
        state = AsyncData([task]);
      } else {
        final index = tasks.indexWhere((t) => task.id == t?.id);
        if (index == -1) {
          state = AsyncData([task, ...tasks]);
        } else {
          final currentTasks = [...tasks];
          currentTasks[index] = task;
          state = AsyncData(currentTasks);
        }
      }
    });
  }

  Future<void> isTaskChanged(Task task) async {
    // Optimistically update the list
    optimisticallyUpdate(task.copyWith(isDone: !task.isDone));

    final repository = ref.read(tasksRepositoryProvider);
    final response = await repository.toggleIsDone(task);

    state = response.fold(
      (exception) {
        // Revert the optimistic update
        optimisticallyUpdate(task);
        return AsyncError(exception, StackTrace.current);
      },
      (_) => state,
    );
  }

  void optimisticallyDelete(Task task) {
    state.whenData((tasks) {
      if (tasks.isEmpty) return;
      final index = tasks.indexWhere((t) => task.id == t?.id);
      if (index != -1) {
        final updatedTasks = tasks.where((t) => task.id != t?.id).toList();
        state = AsyncData(updatedTasks);
      } else {
        return;
      }
    });
  }

  Future<void> deleteTask(Task task) async {
    final tasks = state.valueOrNull;
    if (tasks == null || tasks.isEmpty) return;

    optimisticallyDelete(task);

    final repository = ref.read(tasksRepositoryProvider);
    final response = await repository.deleteTask(task);

    state = response.fold(
      (exception) {
        // Revert the list by putting back the task
        optimisticallyUpdate(task);
        return AsyncError(exception, StackTrace.current);
      },
      (_) => state,
    );
  }
}
