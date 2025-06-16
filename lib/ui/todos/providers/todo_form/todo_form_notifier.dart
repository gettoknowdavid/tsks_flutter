import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/dtos/todos/todo_dto.dart';
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
    final Either<TsksException, Todo> response;

    if (isEditing) {
      final dataToUpdate = <String, dynamic>{};

      final initialDto = TodoDto.fromDomain(initialTodo);
      final initialData = initialDto.toJson();
      final currentData = state.toJson();

      // Dynamically iterate and compare
      currentData.forEach((key, value) {
        // Compare each proper from the state with that from the
        // initial collection, and if a field matches, add that field to the
        // `dataToUpdate` map
        if (!const DeepCollectionEquality().equals(value, initialData[key])) {
          dataToUpdate[key] = value;
        }
      });

      response = await repository.updateTodo(
        uid: initialTodo.uid,
        collectionUid: initialTodo.collectionUid,
        data: dataToUpdate,
      );
    } else {
      response = await repository.createTodo(
        collectionUid: state.collectionUid,
        title: state.title,
        createdAt: state.createdAt,
        dueDate: state.dueDate,
        isDone: state.isDone,
      );
    }

    state = response.fold(
      state.withSubmissionFailure,
      state.withSubmissionSuccess,
    );
  }
}
