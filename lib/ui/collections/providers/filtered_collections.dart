import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/ui/collections/providers/collections_notifier.dart';

part 'filtered_collections.g.dart';

enum CollectionFilter { all, favourites }

extension CollectionFilterX on CollectionFilter {
  String get name => switch (this) {
    CollectionFilter.all => 'All Collections',
    CollectionFilter.favourites => 'Favourites',
  };
}

@riverpod
class FilteredCollections extends _$FilteredCollections {
  @override
  FilteredCollectionState build() {
    final collections = ref.watch(collectionsNotifierProvider).valueOrNull;
    if (collections == null || collections.isEmpty) {
      return const FilteredCollectionState();
    }

    return FilteredCollectionState(collections);
  }

  void updateFilter(CollectionFilter filter) {
    final collections = ref.watch(collectionsNotifierProvider).valueOrNull;
    if (collections == null || collections.isEmpty) {
      state = state.withEmpty();
      return;
    }

    switch (filter) {
      case CollectionFilter.all:
        state = state.withAll(collections);
        return;
      case CollectionFilter.favourites:
        final favouriteCollections = collections
            .where((collection) => collection!.isFavourite)
            .toList();
        state = state.withFavourites(favouriteCollections);
        return;
    }
  }
}

final class FilteredCollectionState with EquatableMixin {
  const FilteredCollectionState([List<Collection?> collections = const []])
    : this._(collections, CollectionFilter.all);

  const FilteredCollectionState._(this.collections, this.filter);

  final List<Collection?> collections;
  final CollectionFilter filter;

  FilteredCollectionState withEmpty() {
    return FilteredCollectionState._(const [], filter);
  }

  FilteredCollectionState withAll(List<Collection?> collections) {
    return FilteredCollectionState._(collections, CollectionFilter.all);
  }

  FilteredCollectionState withFavourites(List<Collection?> collections) {
    return FilteredCollectionState._(collections, CollectionFilter.favourites);
  }

  @override
  List<Object?> get props => [collections, filter];
}

// sealed class FilteredCollectionState with EquatableMixin {
//   const FilteredCollectionState();
//
//   @override
//   List<Object?> get props => [];
// }

// final class AllCollections extends FilteredCollectionState {
//   const AllCollections([List<Collection?> collections = const []])
//     : this._(collections, CollectionFilter.all);
//
//   const AllCollections._(this.collections, this.filter);
//
//   final List<Collection?> collections;
//   final CollectionFilter filter;
//
//   @override
//   List<Object?> get props => [collections, filter];
// }
//
// final class FavouriteCollections extends FilteredCollectionState {
//   const FavouriteCollections([List<Collection?> collections = const []])
//     : this._(collections, CollectionFilter.favourites);
//
//   const FavouriteCollections._(this.collections, this.filter);
//
//   final List<Collection?> collections;
//   final CollectionFilter filter;
//
//   @override
//   List<Object?> get props => [collections, filter];
// }
//
// final class EmptyCollections extends FilteredCollectionState {
//   const EmptyCollections();
// }
