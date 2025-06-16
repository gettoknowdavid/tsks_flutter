import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/todos_repository.dart';
import 'package:tsks_flutter/domain/core/exceptions/exceptions.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';

part 'todos_provider.g.dart';

@riverpod
class Todos extends _$Todos {
  @override
  FutureOr<List<Todo?>> build() async {
    final router = ref.watch(routerConfigProvider);
    final uidString = router.state.pathParameters['uid'];
    final collectionUid = uidString != null ? Uid(uidString) : null;
    if (collectionUid == null) throw const TsksException('Collection needed');

    final repository = ref.read(todosRepositoryProvider);
    final response = await repository.getTodos(collectionUid);
    return response.fold((exception) => throw exception, (todos) => todos);
  }

  void optimisticallyUpdate(Todo todo) {
    state.whenData((data) {
      final todos = [...data];
      final index = todos.indexWhere((t) => todo.uid == t?.uid);
      if (index == -1) {
        state = AsyncData([todo, ...todos]);
      } else {
        todos[index] = todo;
        state = AsyncData(todos);
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
        throw exception;
      },
      (_) => state,
    );
  }
}
