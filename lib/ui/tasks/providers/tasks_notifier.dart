import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/data/repositories/tasks/tasks_repository.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_form/task_form_notifier.dart';
import 'package:uuid/uuid.dart';

part 'tasks_notifier.g.dart';

@Riverpod(keepAlive: true)
class TasksNotifier extends _$TasksNotifier {
  TasksRepository get _repository => ref.read(tasksRepositoryProvider);

  @override
  FutureOr<List<Task?>> build(String? collection) async {
    if (collection == null) throw const NoCollectionFoundException();
    final response = await _repository.getTopLevelTasks(collection);
    return response.fold((exception) => throw exception, (tasks) => tasks);
  }

  // Helper to safely modify the current state (List<Task?>)
  // This ensures the list is always kept sorted by 'updatedAt' for consistency.
  List<Task?> _sortTasks(List<Task?> tasks) {
    final now = DateTime.now();
    final list = tasks.whereType<Task?>().toList();
    list.sort((a, b) => b?.updatedAt?.compareTo(a?.updatedAt ?? now) ?? 0);
    return list;
  }

  void optimisticallyUpdate(Task task) {
    state.whenData((tasks) {
      final currentTasks = List<Task?>.from(tasks);
      final index = currentTasks.indexWhere((t) => task.id == t?.id);

      if (index == -1) {
        state = AsyncData(_sortTasks([task, ...currentTasks]));
      } else {
        currentTasks[index] = task;
        state = AsyncData(_sortTasks(currentTasks));
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

  void optimisticallyDelete(Task task) {
    state.whenData((tasks) {
      if (tasks.isEmpty) return;
      final updatedTasks = tasks.where((t) => task.id != t?.id).toList();
      state = AsyncData(updatedTasks);
    });
  }

  Future<void> createTask() async {
    final taskForm = ref.read(taskFormNotifierProvider);
    final tempId = const Uuid().v4();

    final newTask = Task(
      id: tempId,
      collection: taskForm.collection,
      title: taskForm.title.value,
      parentTask: taskForm.parentTask?.id,
      dueDate: taskForm.dueDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _repository.createTask(newTask);

    state = result.fold(
      (exception) {
        // If creation fails, revert by deleting the optimistically added task
        optimisticallyDelete(newTask);
        return AsyncError(exception, StackTrace.current);
      },
      (createdTask) {
        // Remove placeholder
        optimisticallyDelete(newTask);

        // Replace the optimistic task with the actual task from Firestore
        optimisticallyUpdate(createdTask);
        return state;
      },
    );
  }

  Future<void> deleteTask(Task task) async {
    final originalTasks = state.valueOrNull;
    if (originalTasks == null || originalTasks.isEmpty) return;

    optimisticallyDelete(task);

    final response = await _repository.deleteTask(task);

    state = response.fold(
      (exception) {
        // Revert the list by putting back the task
        state = AsyncData(originalTasks);
        return AsyncError(exception, StackTrace.current);
      },
      (_) => state,
    );
  }

  // You might also want an optimistic update method for general task edits
  Future<void> updateTask(Task task) async {
    final originalTask = task;
    final taskForm = ref.read(taskFormNotifierProvider);

    final updatedTask = originalTask.copyWith(
      title: taskForm.title.value,
      isDone: taskForm.isDone,
      dueDate: taskForm.dueDate,
      collection: taskForm.collection,
      parentTask: taskForm.parentTask?.id,
      updatedAt: DateTime.now(),
    );

    optimisticallyUpdate(updatedTask);

    final response = await _repository.updateTask(
      originalTask: originalTask,
      updatedTask: updatedTask,
    );

    state = response.fold(
      (exception) {
        optimisticallyUpdate(originalTask);
        return AsyncError(exception, StackTrace.current);
      },
      (updatedTaskFromBackend) {
        // Replace the optimistic task with the actual task from Firestore
        // to make sure the `updatedAt` value remains consistent with the
        // Firestore DB
        optimisticallyUpdate(updatedTaskFromBackend);
        return state;
      },
    );
  }
}
