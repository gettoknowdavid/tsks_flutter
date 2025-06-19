import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/todos_repository.dart';
import 'package:tsks_flutter/domain/core/exceptions/exceptions.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';

part 'todos_provider.g.dart';

@riverpod
class Todos extends _$Todos {
  @override
  FutureOr<List<Todo?>> build(Uid? collectionUid) async {
    if (collectionUid == null) throw const TsksException('Collection needed');
    final repository = ref.read(todosRepositoryProvider);
    final response = await repository.getTodos(collectionUid);
    return response.fold((exception) => throw exception, (todos) => todos);
  }

  void optimisticallyUpdate(Todo todo) {
    state.whenData((todos) {
      if (todos.isEmpty) {
        state = AsyncData([todo]);
      } else {
        final index = todos.indexWhere((t) => todo.uid == t?.uid);
        if (index == -1) {
          state = AsyncData([todo, ...todos]);
        } else {
          final currentTodos = [...todos];
          currentTodos[index] = todo;
          state = AsyncData(currentTodos);
        }
      }
    });
  }

  Future<void> isTodoChanged(Todo todo) async {
    // Optimistically update the list
    optimisticallyUpdate(todo);

    final repository = ref.read(todosRepositoryProvider);
    final response = await repository.markTodo(todo);

    state = response.fold(
      (exception) {
        // Revert the optimistic update
        optimisticallyUpdate(todo.copyWith(isDone: !todo.isDone));
        return AsyncError(exception, StackTrace.current);
      },
      (_) => state,
    );
  }

  Future<void> deleteTodo(Todo todo) async {
    final todos = state.valueOrNull;
    if (todos == null || todos.isEmpty) return;

    final index = todos.indexWhere((t) => todo.uid == t?.uid);
    if (index != -1) {
      final updatedTodos = todos.where((t) => todo.uid != t?.uid).toList();
      state = AsyncData(updatedTodos);
    } else {
      return;
    }

    final repository = ref.read(todosRepositoryProvider);
    final response = await repository.deleteTodo(todo);

    state = response.fold(
      (exception) {
        // Revert the list by putting back the todo
        optimisticallyUpdate(todo);
        return AsyncError(exception, StackTrace.current);
      },
      (_) => state,
    );
  }
}
