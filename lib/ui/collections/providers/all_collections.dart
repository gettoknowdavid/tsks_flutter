import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/collections/collections_repository.dart';
import 'package:tsks_flutter/models/collections/collection.dart';

part 'all_collections.g.dart';

@riverpod
class AllCollections extends _$AllCollections {
  @override
  FutureOr<List<Collection?>> build() async {
    final repository = ref.read(collectionsRepositoryProvider);
    final response = await repository.getCollections();
    return response.fold(
      (exception) => throw exception,
      (collections) => collections,
    );
  }

  void optimisticallyUpdate(Collection collection) {
    state.whenData((collections) {
      if (collections.isEmpty) {
        state = AsyncData([collection]);
      } else {
        final index = collections.indexWhere((c) => c?.id == collection.id);
        if (index == -1) {
          state = AsyncData([collection, ...collections]);
        } else {
          final currentCollections = [...collections];
          currentCollections[index] = collection;
          state = AsyncData(currentCollections);
        }
      }
    });
  }

  void optimisticallyDelete(String collectionId) {
    state.whenData((collections) {
      if (collections.isEmpty) return;
      final updatedCollections = collections
          .where((collection) => collection?.id != collectionId)
          .toList();
      state = AsyncData(updatedCollections);
    });
  }
}
