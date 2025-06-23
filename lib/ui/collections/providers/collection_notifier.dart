import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/data/repositories/collections/collections_repository.dart';
import 'package:tsks_flutter/models/collections/collection.dart';

part 'collection_notifier.g.dart';

@riverpod
class CollectionNotifier extends _$CollectionNotifier {
  @override
  FutureOr<Collection> build(String? id) async {
    if (id == null) throw const NoCollectionFoundException();

    final repository = ref.read(collectionsRepositoryProvider);
    final response = await repository.getCollection(id);
    return response.fold(
      (exception) => throw exception,
      (collection) => collection,
    );
  }

  void optimisticallyUpdate(Collection updatedCollection) {
    if (id == null) {
      state = AsyncError(
        const NoCollectionFoundException(),
        StackTrace.current,
      );
    } else {
      state = AsyncData(updatedCollection);
    }
  }
}
