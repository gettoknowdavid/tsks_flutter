import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/services/cloud_firestore.dart';
import 'package:tsks_flutter/domain/core/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/ui/auth/providers/session/session.dart';

part 'collections_repository.g.dart';

@riverpod
CollectionsRepository collectionsRepository(Ref ref) {
  final userDocumentReference = ref.read(userDocumentReferenceProvider);
  return CollectionsRepository(userDocumentReference: userDocumentReference);
}

final class CollectionsRepository {
  const CollectionsRepository({
    required DocumentReference<User> userDocumentReference,
  }) : _userDocumentReference = userDocumentReference;

  final DocumentReference<User> _userDocumentReference;

  CollectionReference<Map<String, dynamic>> get _collectionReference {
    return _userDocumentReference.collection('collections');
  }

  Future<Either<TsksException, Collection>> createCollection({
    required SingleLineString title,
    bool? isFavourite = false,
    int? colorARGB,
    Map<String, dynamic>? iconMap,
  }) async {
    try {
      final documentReference = await _collectionReference.add({
        'ownerUid': _userDocumentReference.id,
        'title': title.getOrCrash,
        'isFavourite': isFavourite ?? false,
        'colorARGB': colorARGB,
        'iconMap': iconMap,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final snapshot = await documentReference.collectionConverter.get();
      final collectionDto = snapshot.data();

      if (collectionDto == null) {
        return const Left(TsksException('An error unknown occurred.'));
      }

      return Right(collectionDto.toDomain());
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Collection>> updateCollection({
    required Uid uid,
    required Map<String, dynamic> data,
  }) async {
    if (data.isEmpty) return const Left(NoCollectionFoundException());

    try {
      final documentReference = _collectionReference.doc(uid.getOrCrash);

      await documentReference.update(data);

      final snapshot = await documentReference.collectionConverter.get();
      final collectionDto = snapshot.data();

      if (collectionDto == null) {
        return const Left(TsksException('An error unknown occurred.'));
      }

      return Right(collectionDto.toDomain());
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Uid>> deleteCollection(Uid uid) async {
    try {
      await _collectionReference.doc(uid.getOrCrash).delete();
      return Right(uid);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, List<Collection?>>> getCollections() async {
    try {
      final querySnapshot = await _collectionReference.collectionConverter
          .orderBy('updatedAt', descending: true)
          .get();

      final collections = querySnapshot.docs
          .map((snapshot) => snapshot.data()?.toDomain())
          .toList();

      return Right(collections);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Collection>> getCollection(Uid uid) async {
    try {
      final uidStr = uid.getOrCrash;
      final doc = await _collectionReference.collectionConverter
          .doc(uidStr)
          .get();
      final collection = doc.data()?.toDomain();
      if (collection == null) return const Left(NoCollectionFoundException());
      return Right(collection);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, int>> getNumberOfTodos(Uid uid) async {
    try {
      final uidStr = uid.getOrCrash;
      final aggregateQuery = _collectionReference
          .doc(uidStr)
          .collection('todos')
          .count();
      final countQuery = await aggregateQuery.get();
      return Right(countQuery.count ?? 0);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, int>> getNumberOfDoneTodos(Uid uid) async {
    try {
      final uidStr = uid.getOrCrash;
      final reference = _collectionReference.doc(uidStr).collection('todos');
      final aggregateQuery = reference.where('isDone', isEqualTo: true).count();
      final countQuery = await aggregateQuery.get();
      return Right(countQuery.count ?? 0);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }
}
