import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/tasks/tasks_repository.dart';
import 'package:tsks_flutter/models/tasks/task.dart';

part 'sub_tasks_notifier.g.dart';

@riverpod
class SubTasksNotifier extends _$SubTasksNotifier {
  @override
  FutureOr<List<Task?>> build({
    required String collection,
    required String parentTask,
  }) async {
    final repository = ref.read(tasksRepositoryProvider);

    final response = await repository.getSubTasks(
      collection: collection,
      parentTask: parentTask,
    );

    return response.fold((exception) => throw exception, (tasks) => tasks);
  }
}
