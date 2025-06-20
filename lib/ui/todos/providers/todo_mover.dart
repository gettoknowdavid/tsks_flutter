import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/todos_repository.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';
import 'package:tsks_flutter/ui/todos/providers/todos_provider.dart';

part 'todo_mover.g.dart';

@riverpod
class TodoMover extends _$TodoMover {
  @override
  AsyncValue<Todo?> build() {
    listenSelf((previous, next) {
      if (previous == next) return;
      switch (next) {
        case AsyncData(:final value):
          if (value == null) return;
          final newCollectionUid = value.collectionUid;
          ref
              .read(todosProvider(newCollectionUid).notifier)
              .optimisticallyUpdate(value);
      }
    });

    return const AsyncData(null);
  }

  Future<void> moveTodoToCollection(Todo todo, Uid collectionUid) async {
    state = const AsyncLoading();
    final repository = ref.read(todosRepositoryProvider);
    final response = await repository.moveTodoToCollection(todo, collectionUid);
    state = response.fold(
      (exception) => AsyncError(exception, StackTrace.current),
      (movedTodo) {
        return AsyncData(movedTodo);
      },
    );
  }
}
