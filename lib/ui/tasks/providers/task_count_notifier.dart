import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/data/repositories/tasks/tasks_repository.dart';
import 'package:tsks_flutter/ui/tasks/providers/tasks_notifier.dart';

part 'task_count_notifier.g.dart';

@riverpod
class TaskCountNotifier extends _$TaskCountNotifier {
  // Use a private variable to store the initial count result
  // This will be set only once when the build method first runs
  int? _initialFetchedCount;

  @override
  FutureOr<int> build({
    required String title,
    String? collection,
    bool? isDone,
  }) async {
    if (collection == null) throw const NoCollectionFoundException();
    // If the initial count hasn't been fetched yet, do it now.
    // This part runs only once per provider instance.
    if (_initialFetchedCount == null) {
      final repository = ref.read(tasksRepositoryProvider);
      final res = await repository.getNumberOfTasks(collection, isDone: isDone);
      _initialFetchedCount = res.fold((_) => 0, (count) => count);
    }

    // Now, watch the tasks provider to update the count
    final tasksAsync = ref.watch(tasksNotifierProvider(collection));

    return tasksAsync.when(
      error: (error, stackTrace) => _initialFetchedCount ?? 0,
      loading: () => _initialFetchedCount ?? 0,
      data: (tasks) {
        if (isDone == null) return tasks.length;
        return tasks.where((t) => t?.isDone == isDone).toList().length;
      },
    );
  }
}
