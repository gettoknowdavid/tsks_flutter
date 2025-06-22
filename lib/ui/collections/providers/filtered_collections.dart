import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/ui/collections/providers/all_collections.dart';
import 'package:tsks_flutter/ui/collections/providers/collection_filter_notifier.dart';

part 'filtered_collections.g.dart';

@Riverpod(keepAlive: true)
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
