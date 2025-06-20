import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/collections_repository.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/ui/todos/providers/todos_provider.dart';

part 'collection_todos_count.g.dart';

@riverpod
class CollectionTodosCount extends _$CollectionTodosCount {
  // Use a private variable to store the initial count result
  // This will be set only once when the build method first runs
  int? _initialFetchedCount;

  @override
  Future<int> build(Uid collectionUid) async {
    // If the initial count hasn't been fetched yet, do it now.
    // This part runs only once per provider instance.
    if (_initialFetchedCount == null) {
      final repository = ref.read(collectionsRepositoryProvider);
      final response = await repository.getNumberOfTodos(collectionUid);
      _initialFetchedCount = response.fold((_) => 0, (count) => count);
    }

    // Now, watch the todos provider to update the count
    final todosAsync = ref.watch(todosProvider(collectionUid));

    return todosAsync.when(
      data: (todos) => todos.length,
      error: (error, stackTrace) => _initialFetchedCount ?? 0,
      loading: () => _initialFetchedCount ?? 0,
    );
  }
}

@riverpod
class CollectionDoneTodosCount extends _$CollectionDoneTodosCount {
  int? _initialFetchedCount;

  @override
  Future<int> build(Uid collectionUid) async {
    if (_initialFetchedCount == null) {
      final repository = ref.read(collectionsRepositoryProvider);
      final response = await repository.getNumberOfDoneTodos(collectionUid);
      _initialFetchedCount = response.fold((_) => 0, (count) => count);
    }

    final todosAsync = ref.watch(todosProvider(collectionUid));

    return todosAsync.when(
      data: (todos) => todos.where((todo) => todo?.isDone ?? false).length,
      error: (error, stackTrace) => _initialFetchedCount ?? 0,
      loading: () => _initialFetchedCount ?? 0,
    );
  }
}
