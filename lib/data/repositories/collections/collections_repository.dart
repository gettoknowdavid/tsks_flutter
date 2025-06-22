import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/data/services/cloud_firestore.dart';
import 'package:tsks_flutter/models/auth/user.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/ui/auth/providers/session.dart';
import 'package:tsks_flutter/utils/get_model_difference.dart';

part 'collections_repository.g.dart';

@riverpod
CollectionReference<Map<String, dynamic>> collectionReference(Ref ref) {
  return ref.read(firestoreProvider).collection('collections');
}

@riverpod
CollectionsRepository collectionsRepository(Ref ref) {
  final userDocumentReference = ref.read(userDocumentReferenceProvider);
  final collectionReference = ref.read(collectionReferenceProvider);
  return CollectionsRepository(
    userDocumentReference: userDocumentReference,
    collectionReference: collectionReference,
  );
}

final class CollectionsRepository {
  const CollectionsRepository({
    required DocumentReference<User> userDocumentReference,
    required CollectionReference<Map<String, dynamic>> collectionReference,
  }) : _userDocumentReference = userDocumentReference,
       _collectionReference = collectionReference;

  final DocumentReference<User> _userDocumentReference;
  final CollectionReference<Map<String, dynamic>> _collectionReference;

  Future<Either<TsksException, Collection>> createCollection({
    required String title,
    bool? isFavourite = false,
    int? colorARGB,
    Map<String, dynamic>? iconMap,
  }) async {
    try {
      final documentReference = await _collectionReference.add({
        'creator': _userDocumentReference.id,
        'title': title,
        'isFavourite': isFavourite ?? false,
        'colorARGB': colorARGB,
        'iconMap': iconMap,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final snapshot = await documentReference.collectionConverter.get();
      final result = snapshot.data();

      if (result == null) return const Left(NoCollectionFoundException());
      return Right(result);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, String>> deleteCollection(String id) async {
    try {
      await _collectionReference.doc(id).delete();
      return Right(id);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Collection>> getCollection(String id) async {
    try {
      final doc = await _collectionReference.doc(id).collectionConverter.get();
      final collection = doc.data();
      if (collection == null) return const Left(NoCollectionFoundException());
      return Right(collection);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, List<Collection?>>> getCollections({
    int limit = 10,
    DocumentSnapshot<Map<String, dynamic>>? startAfterDocument,
  }) async {
    try {
      final creator = _userDocumentReference.id;
      var query = _collectionReference.collectionConverter
          .orderBy('updatedAt', descending: true)
          .where('creator', isEqualTo: creator)
          .limit(limit);

      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      final querySnapshot = await query.get();
      final collections = querySnapshot.docs.map((s) => s.data()).toList();
      return Right(collections);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      log(e.toString());
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Collection>> updateCollection({
    required Collection originalCollection,
    required Collection updatedCollection,
  }) async {
    try {
      final data = getModelDifference<Collection>(
        originalCollection,
        updatedCollection,
        Collection.schema,
        deepCompare: Collection.deepCompareFields,
      );

      // Always update 'updatedAt' for any change
      data['updatedAt'] = FieldValue.serverTimestamp();

      // Only send update if there are actual changes excluding `updatedAt`
      if (data.length == 1 && data.containsKey('updatedAt')) {
        return Right(originalCollection);
      }

      final documentReference = _collectionReference.doc(updatedCollection.id);
      await documentReference.update(data);

      final snapshot = await documentReference.collectionConverter.get();
      final result = snapshot.data();

      if (result == null) return const Left(NoCollectionFoundException());
      return Right(result);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }
}

extension CollectionsCollectionReferenceX on CollectionReference {
  CollectionReference<Collection?> get collectionConverter {
    return withConverter<Collection>(
      fromFirestore: (snapshot, _) => Collection.fromFirestore(snapshot),
      toFirestore: (model, _) => model.toFirestore(),
    );
  }
}

extension CollectionsDocumentReferenceX on DocumentReference {
  DocumentReference<Collection?> get collectionConverter {
    return withConverter<Collection>(
      fromFirestore: (snapshot, _) => Collection.fromFirestore(snapshot),
      toFirestore: (model, _) => model.toFirestore(),
    );
  }
}
