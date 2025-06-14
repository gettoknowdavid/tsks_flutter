import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/collections_repository.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/ui/todos/providers/collection_filter.dart';

part 'collections_provider.g.dart';

@riverpod
FutureOr<List<Collection?>> allCollections(Ref ref) async {
  final repository = ref.read(collectionsRepositoryProvider);
  final response = await repository.getCollections();
  return response.fold(
    (exception) => throw exception,
    (collections) => collections,
  );
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
