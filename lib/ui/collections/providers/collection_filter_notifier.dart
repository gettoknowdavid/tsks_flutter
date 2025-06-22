import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collection_filter_notifier.g.dart';

@riverpod
class CollectionFilterNotifier extends _$CollectionFilterNotifier {
  @override
  CollectionFilter build() => CollectionFilter.all;

  void updateFilter(CollectionFilter filter) {
    state = filter;
    return;
  }
}

enum CollectionFilter { all, favourites }

extension CollectionFilterX on CollectionFilter {
  String get name => switch (this) {
    CollectionFilter.all => 'All Collections',
    CollectionFilter.favourites => 'Favourites',
  };
}
