import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart' hide Task;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/data/repositories/tasks/tasks_repository.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/ui/core/models/models.dart';

part 'task_form_notifier.g.dart';
part 'task_form_state.dart';

@Riverpod(keepAlive: true)
class TaskFormNotifier extends _$TaskFormNotifier {
  @override
  TaskFormState build() => const TaskFormState();

  void collectionChanged(String? collectionId) {
    if (collectionId == null) return;
    state = state.withCollectionId(collectionId);
  }

  void parentTaskChanged(Task todo) => state = state.withParentTask(todo);

  void titleChanged(String title) => state = state.withTitle(title);

  void isDoneChanged(bool? value) => state = state.withIsDone(value);

  void dueDateChanged(DateTime? dueDate) => state = state.withDueDate(dueDate);

  void initializeWithTask(Task todo) => state = state.withTask(todo);

  Future<void> submit() async {
    // Validate the form
    if (state.isNotValid) return;

    // Check if the form is in edit mode
    final initialTask = state.initialTask;
    final isEditing = initialTask != null;

    // If editing, but no changes were made, we can consider it a success
    // and avoid a pointless database write.
    if (isEditing && !state.hasChanges) return;

    state = state.withSubmissionInProgress();

    final repository = ref.read(tasksRepositoryProvider);
    Either<TsksException, Task> response;

    if (isEditing) {
      response = await repository.updateTask(
        originalTask: initialTask,
        updatedTask: initialTask.copyWith(
          title: state.title.value,
          isDone: state.isDone,
          dueDate: state.dueDate,
          collection: state.collectionId,
          parentTask: state.parentTask?.id,
        ),
      );
    } else {
      response = await repository.createTask(
        collection: state.collectionId,
        title: state.title.value,
        isDone: state.isDone,
        dueDate: state.dueDate,
        parentTask: state.parentTask?.id,
      );
    }

    state = response.fold(
      state.withSubmissionFailure,
      state.withSubmissionSuccess,
    );
  }
}
