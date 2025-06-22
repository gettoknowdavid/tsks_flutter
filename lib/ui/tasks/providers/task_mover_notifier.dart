import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/tasks/tasks_repository.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/ui/tasks/providers/tasks_notifier.dart';

part 'task_mover_notifier.g.dart';

@riverpod
class TaskMoverNotifier extends _$TaskMoverNotifier {
  @override
  AsyncValue<Task?> build() {
    listenSelf((previous, next) {
      if (previous == next) return;

      next.whenData(
        (movedTask) {
          if (movedTask == null) return;
          final collectionId = movedTask.collection;
          final tasks = ref.read(tasksNotifierProvider(collectionId).notifier);
          tasks.optimisticallyUpdate(movedTask);
        },
      );
    });

    return const AsyncData(null);
  }

  Future<void> moveTaskToCollection(Task todo, String collection) async {
    state = const AsyncLoading();
    final repository = ref.read(tasksRepositoryProvider);
    final response = await repository.moveTaskToCollection(todo, collection);
    state = response.fold(
      (exception) => AsyncError(exception, StackTrace.current),
      AsyncData.new,
    );
  }
}
