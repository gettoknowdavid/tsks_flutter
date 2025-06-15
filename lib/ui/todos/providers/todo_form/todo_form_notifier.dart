import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/todos_repository.dart';
import 'package:tsks_flutter/domain/core/exceptions/exceptions.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';

part 'todo_form_notifier.g.dart';
part 'todo_form_state.dart';

@riverpod
class TodoForm extends _$TodoForm {
  @override
  TodoFormState build() => TodoFormState();

  void collectionChanged(Uid uid) => state = state.withCollectionUid(uid);

  void titleChanged(String title) => state = state.withTitle(title);

  void isDoneChanged(bool? value) => state = state.withIsDone(value);

  void dueDateChanged(DateTime? dueDate) => state = state.withDueDate(dueDate);

  void initializeWithTodo(Todo todo) => state = state.withTodo(todo);

  Future<void> submit() async {
    // Validate the form
    if (!state.isFormValid) return;

    state = state.withSubmissionProgress();
    final repository = ref.read(todosRepositoryProvider);

    final response = await repository.createTodo(
      collectionUid: state.collectionUid,
      title: state.title,
      createdAt: state.createdAt,
      dueDate: state.dueDate,
      isDone: state.isDone,
    );

    state = response.fold(
      state.withSubmissionFailure,
      state.withSubmissionSuccess,
    );
  }
}
