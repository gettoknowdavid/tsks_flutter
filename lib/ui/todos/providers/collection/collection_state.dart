part of 'collection_notifier.dart';

final class CollectionState with EquatableMixin {
  CollectionState() : this._(collection: Collection.empty);

  const CollectionState._({
    required this.collection,
    this.status = CollectionStatus.initial,
    this.exception,
  });

  CollectionState withInitialize(Collection collection) {
    return CollectionState._(
      collection: collection,
      status: CollectionStatus.loading,
    );
  }

  CollectionState withCollection(Collection collection) {
    return CollectionState._(collection: collection);
  }

  CollectionState withLoadInProgress() {
    return CollectionState._(
      collection: collection,
      status: CollectionStatus.loading,
    );
  }

  CollectionState withLoadFailure(TsksException exception) {
    return CollectionState._(
      collection: collection,
      status: CollectionStatus.failure,
      exception: exception,
    );
  }

  final Collection collection;
  final CollectionStatus status;
  final TsksException? exception;

  @override
  List<Object?> get props => [collection, status, exception];
}

enum CollectionStatus { initial, loading, success, failure }

extension CollectionStatusX on CollectionStatus {
  bool get isInitial => this == CollectionStatus.initial;
  bool get isLoading => this == CollectionStatus.loading;
  bool get isSuccess => this == CollectionStatus.success;
  bool get isFailure => this == CollectionStatus.failure;
}
