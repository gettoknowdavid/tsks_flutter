import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/todos_repository.dart';
import 'package:tsks_flutter/domain/core/exceptions/exceptions.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';

part 'todo_form_notifier.g.dart';
part 'todo_form_state.dart';

@Riverpod(keepAlive: true)
class TodoForm extends _$TodoForm {
  @override
  TodoFormState build() => TodoFormState();

  void collectionChanged(Uid? uid) {
    if (uid == null) return;
    state = state.withCollectionUid(uid);
  }

  void parentTodoChanged(Todo todo) => state = state.withParentTodo(todo);

  void titleChanged(String title) => state = state.withTitle(title);

  void isDoneChanged(bool? value) => state = state.withIsDone(value);

  void dueDateChanged(DateTime? dueDate) => state = state.withDueDate(dueDate);

  void initializeWithTodo(Todo todo) => state = state.withTodo(todo);

  Future<void> submit() async {
    // Validate the form
    if (!state.isFormValid) return;

    // Check if the form is in edit mode
    final initialTodo = state.initialTodo;
    final isEditing = initialTodo != null;

    state = state.withSubmissionProgress();
    final repository = ref.read(todosRepositoryProvider);
    Either<TsksException, Todo> response;

    if (isEditing) {
      final dataToUpdate = <String, dynamic>{};

      if (state.title != initialTodo.title) {
        dataToUpdate['title'] = state.title.getOrCrash;
      }

      if (state.isDone != initialTodo.isDone) {
        dataToUpdate['isDone'] = state.isDone;
      }

      if (state.dueDate != initialTodo.dueDate) {
        dataToUpdate['dueDate'] = state.dueDate;
      }

      if (dataToUpdate.isNotEmpty) {
        dataToUpdate['updatedAt'] = FieldValue.serverTimestamp();
        response = await repository.updateTodo(
          uid: initialTodo.uid,
          collectionUid: initialTodo.collectionUid,
          data: dataToUpdate,
          parentTodoUid: initialTodo.parentTodoUid,
        );
      } else {
        // Nothing changed, so we can exit early.
        response = Right(initialTodo);
      }
    } else {
      response = await repository.createTodo(
        collectionUid: state.collectionUid,
        title: state.title,
        dueDate: state.dueDate,
        isDone: state.isDone,
        parentTodoUid: state.parentTodo?.uid,
      );
    }

    state = response.fold(
      state.withSubmissionFailure,
      state.withSubmissionSuccess,
    );
  }
}
