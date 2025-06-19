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

    // if (isEditing) {
    //   final dataToUpdate = <String, dynamic>{};
    //
    //   final initialDto = TodoDto.fromDomain(initialTodo);
    //   final initialData = initialDto.toJson();
    //   final currentData = state.toJson();
    //
    //   // Dynamically iterate and compare
    //   currentData.forEach((key, value) {
    //     // Compare each proper from the state with that from the
    //     // initial collection, and if a field matches, add that field to the
    //     // `dataToUpdate` map
    //     if (!const DeepCollectionEquality().equals(value, initialData[key])) {
    //       dataToUpdate[key] = value;
    //     }
    //   });
    //
    //   response = await repository.updateTodo(
    //     uid: initialTodo.uid,
    //     collectionUid: initialTodo.collectionUid,
    //     data: dataToUpdate,
    //     parentTodoUid: initialTodo.parentTodoUid,
    //   );
    // } else {
    //   response = await repository.createTodo(
    //     collectionUid: state.collectionUid,
    //     title: state.title,
    //     createdAt: state.createdAt,
    //     dueDate: state.dueDate,
    //     isDone: state.isDone,
    //     parentTodoUid: state.parentTodo?.uid,
    //   );
    // }

    if (isEditing) {
      // Check if the collection or parent has changed
      final hasMoved =
          state.collectionUid != initialTodo.collectionUid ||
          state.parentTodo?.uid != initialTodo.parentTodoUid;

      if (hasMoved) {
        if (initialTodo.parentTodoUid != null) {
          // It's a sub-todo being moved
          response = await repository
              .moveSubTodo(
                subTodoToMove: initialTodo.copyWith(
                  title: state.title,
                  isDone: state.isDone,
                  dueDate: state.dueDate,
                ), // Pass updated data
                newCollectionUid: state.collectionUid,
                newParentTodoUid: state.parentTodo!.uid,
              )
              .then(
                (either) => either.map((_) => initialTodo),
              ); // Adjust return type if needed
        } else {
          // It's a top-level todo being moved
          response = await repository
              .moveTodoToCollection(
                todoToMove: initialTodo.copyWith(
                  title: state.title,
                  isDone: state.isDone,
                  dueDate: state.dueDate,
                ), // Pass updated data
                newCollectionUid: state.collectionUid,
              )
              .then(
                (either) => either.map((_) => initialTodo),
              ); // Adjust return type if needed
        }
      } else {
        // --- HANDLE THE SIMPLE UPDATE SCENARIO (NO MOVE) ---
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
      }
    } else {
      response = await repository.createTodo(
        collectionUid: state.collectionUid,
        title: state.title,
        createdAt: state.createdAt,
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
