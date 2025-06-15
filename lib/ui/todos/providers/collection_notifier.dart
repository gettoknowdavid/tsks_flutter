import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/collections_repository.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/ui/todos/providers/collections/collections_provider.dart';

part 'collection_notifier.g.dart';

@riverpod
class CollectionNotifier extends _$CollectionNotifier {
  @override
  FutureOr<Collection> build(Uid uid) async {
    final repository = ref.read(collectionsRepositoryProvider);
    final response = await repository.getCollection(uid);
    return response.fold(
      (exception) => throw exception,
      (collection) => collection,
    );
  }

  void optimisticallyUpdate(Collection updatedCollection) {
    state = AsyncData(updatedCollection);
  }

  Future<void> deleteCollection() async {
    state = const AsyncLoading();
    final repository = ref.read(collectionsRepositoryProvider);
    final response = await repository.deleteCollection(uid);
    response.fold(
      (exception) => state = AsyncError(exception, StackTrace.current),
      (_) {
        ref.read(allCollectionsProvider.notifier).optimisticallyDelete(uid);
        ref.invalidateSelf();
      },
    );
  }
}
