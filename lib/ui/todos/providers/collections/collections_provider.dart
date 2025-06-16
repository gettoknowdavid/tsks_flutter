import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/collections_repository.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/ui/todos/providers/collection_filter.dart';

part 'collections_provider.g.dart';

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
        final index = collections.indexWhere((c) => c?.uid == collection.uid);
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

  void optimisticallyDelete(Uid collectionUid) {
    state.whenData((collections) {
      if (collections.isEmpty) return;
      final updatedCollections = collections
          .where((collection) => collection?.uid != collectionUid)
          .toList();
      state = AsyncData(updatedCollections);
    });
  }
}

@riverpod
List<Collection?> filteredCollections(Ref ref) {
  final allCollectionsAsyncValue = ref.watch(allCollectionsProvider);
  final filter = ref.watch(collectionFilterNotifierProvider);

  if (allCollectionsAsyncValue is AsyncError) return [];

  final all = allCollectionsAsyncValue.valueOrNull ?? [];

  if (all.isEmpty) return [];

  switch (filter) {
    case CollectionFilter.all:
      return all;
    case CollectionFilter.favourites:
      return all.where((collection) => collection!.isFavourite).toList();
  }
}
