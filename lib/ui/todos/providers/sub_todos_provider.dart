import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/todos_repository.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';

part 'sub_todos_provider.g.dart';

@riverpod
class SubTodos extends _$SubTodos {
  @override
  FutureOr<List<Todo?>> build({
    required Uid collectionUid,
    required Uid parentTodoUid,
  }) async {
    final repository = ref.read(todosRepositoryProvider);

    final response = await repository.getSubTodos(
      collectionUid: collectionUid,
      parentTodoUid: parentTodoUid,
    );

    return response.fold((exception) => throw exception, (todos) => todos);
  }
}
