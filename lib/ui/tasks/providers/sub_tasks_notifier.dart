import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/tasks/tasks_repository.dart';
import 'package:tsks_flutter/models/tasks/task.dart';

part 'sub_tasks_notifier.g.dart';

@Riverpod(keepAlive: true)
class SubTasksNotifier extends _$SubTasksNotifier {
  TasksRepository get _repository => ref.read(tasksRepositoryProvider);

  @override
  FutureOr<List<Task?>> build({
    required String collection,
    required String parentTask,
  }) async {
    final response = await _repository.getSubTasks(
      collection: collection,
      parentTask: parentTask,
    );

    return response.fold((exception) => throw exception, (tasks) => tasks);
  }

  void optimisticallyUpdate(Task task) {
    state.whenData((tasks) {
      final currentTasks = List<Task?>.from(tasks);
      final index = currentTasks.indexWhere((t) => task.id == t?.id);

      if (index == -1) {
        state = AsyncData([task, ...currentTasks]);
      } else {
        currentTasks[index] = task;
        state = AsyncData(currentTasks);
      }
    });
  }

  Future<void> isTaskChanged(Task task) async {
    final originalTask = task;

    // Optimistically update the list with the new 'isDone' status
    optimisticallyUpdate(originalTask.copyWith(isDone: !originalTask.isDone));

    final response = await _repository.toggleIsDone(originalTask);

    state = response.fold(
      (exception) {
        // Revert the optimistic update
        optimisticallyUpdate(originalTask);
        return AsyncError(exception, StackTrace.current);
      },
      (_) => state,
    );
  }
}
