import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/collections/collections_repository.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/ui/auth/providers/session.dart';
import 'package:tsks_flutter/ui/collections/providers/collection_form/collection_form_notifier.dart';
import 'package:uuid/uuid.dart';

part 'collections_notifier.g.dart';

@riverpod
class CollectionsNotifier extends _$CollectionsNotifier {
  CollectionsRepository get _repository {
    return ref.read(collectionsRepositoryProvider);
  }

  @override
  FutureOr<List<Collection?>> build() async {
    final response = await _repository.getCollections();
    return response.fold((exception) => throw exception, (success) => success);
  }

  // Helper to safely modify the current state (List<Collection?>)
  // This ensures the list is always kept sorted by 'updatedAt' for consistency.
  List<Collection?> _sortList(List<Collection?> collections) {
    final now = DateTime.now();
    final list = collections.whereType<Collection?>().toList();
    list.sort((a, b) => b?.updatedAt?.compareTo(a?.updatedAt ?? now) ?? 0);
    return list;
  }

  void optimisticallyUpdate(Collection collections) {
    state.whenData((collectionss) {
      final oldCollections = List<Collection?>.from(collectionss);
      final index = oldCollections.indexWhere((c) => collections.id == c?.id);

      if (index == -1) {
        state = AsyncData(_sortList([collections, ...oldCollections]));
      } else {
        oldCollections[index] = collections;
        state = AsyncData(_sortList(oldCollections));
      }
    });
  }

  void optimisticallyDelete(Collection collection) {
    state.whenData((collections) {
      if (collections.isEmpty) return;
      final updatedCollections = collections
          .where((c) => collection.id != c?.id)
          .toList();
      state = AsyncData(updatedCollections);
    });
  }

  Future<void> createCollection() async {
    final creator = ref.read(sessionProvider.select((s) => s.value?.id));
    if (creator == null) return;

    final collectionForm = ref.read(collectionFormNotifierProvider);
    final tempId = const Uuid().v4();

    final newCollection = Collection(
      id: tempId,
      creator: creator,
      title: collectionForm.title.value,
      isFavourite: collectionForm.isFavourite,
      colorARGB: collectionForm.color?.toARGB32(),
      iconMap: collectionForm.iconMap,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _repository.createCollection(newCollection);

    state = result.fold(
      (exception) {
        // If creation fails, revert by deleting the optimistically added
        // collection
        optimisticallyDelete(newCollection);
        return AsyncError(exception, StackTrace.current);
      },
      (createdCollection) {
        // Remove placeholder
        optimisticallyDelete(newCollection);

        // Replace the optimistic collection with the actual collection from
        // Firestore
        optimisticallyUpdate(createdCollection);
        return state;
      },
    );
  }

  Future<void> deleteCollection(Collection collection) async {
    final originalCollections = state.valueOrNull;
    if (originalCollections == null || originalCollections.isEmpty) return;

    optimisticallyDelete(collection);

    final response = await _repository.deleteCollection(collection.id);

    state = response.fold(
      (exception) {
        // Revert the list by putting back the collection
        state = AsyncData(originalCollections);
        return AsyncError(exception, StackTrace.current);
      },
      (_) => state,
    );
  }

  Future<void> updateColleciton(Collection collection) async {
    final collectionForm = ref.read(collectionFormNotifierProvider);

    final originalCollection = collection;
    final updatedCollection = originalCollection.copyWith(
      title: collectionForm.title.value,
      iconMap: collectionForm.iconMap,
      colorARGB: collectionForm.color?.toARGB32(),
      isFavourite: collectionForm.isFavourite,
      updatedAt: DateTime.now(),
    );

    optimisticallyUpdate(updatedCollection);

    final response = await _repository.updateCollection(
      originalCollection: originalCollection,
      updatedCollection: updatedCollection,
    );

    state = response.fold(
      (exception) {
        optimisticallyUpdate(originalCollection);
        return AsyncError(exception, StackTrace.current);
      },
      (updatedCollectionFromBackend) {
        // Replace the optimistic collection with the actual collection from
        // Firestore to make sure the `updatedAt` value remains consistent
        // with the Firestore DB
        optimisticallyUpdate(updatedCollectionFromBackend);
        return state;
      },
    );
  }
}
