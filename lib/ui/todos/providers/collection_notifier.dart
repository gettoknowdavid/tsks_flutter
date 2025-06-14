import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/collections_repository.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';

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
}
