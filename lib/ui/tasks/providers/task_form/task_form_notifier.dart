import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/ui/core/models/models.dart';

part 'task_form_notifier.g.dart';
part 'task_form_state.dart';

@Riverpod(keepAlive: true)
class TaskFormNotifier extends _$TaskFormNotifier {
  @override
  TaskFormState build() => const TaskFormState();

  void collectionChanged(String? collection) {
    if (collection == null) return;
    state = state.withCollection(collection);
  }

  void titleChanged(String title) => state = state.withTitle(title);

  void isDoneChanged(bool? value) => state = state.withIsDone(value);

  void dueDateChanged(DateTime? dueDate) => state = state.withDueDate(dueDate);

  void initializeWithTask(Task todo) => state = state.withTask(todo);
}
