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
  final userDocRef = ref.read(userDocumentReferenceProvider);
  return CollectionsRepository(userDocRef: userDocRef);
}

final class CollectionsRepository {
  const CollectionsRepository({
    required DocumentReference<User> userDocRef,
  }) : _userDocRef = userDocRef;

  final DocumentReference<User> _userDocRef;

  CollectionReference<Map<String, dynamic>> get _collectionRef {
    return _userDocRef.collection('collections');
  }

  Future<Either<TsksException, Collection>> createCollection({
    required SingleLineString title,
    required DateTime createdAt,
    bool? isFavourite = false,
    int? colorARGB,
    Map<String, dynamic>? iconMap,
  }) async {
    try {
      final documentReference = await _collectionRef.add({
        'title': title.getOrCrash,
        'isFavourite': isFavourite,
        'colorARGB': colorARGB,
        'iconMap': iconMap,
        'createdAt': createdAt.toIso8601String(),
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
      final documentReference = _collectionRef.doc(uid.getOrCrash);

      await _collectionRef.doc(uid.getOrCrash).update(data);

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

  Future<Either<TsksException, List<Collection?>>> getCollections() async {
    try {
      final querySnapshot = await _collectionRef.collectionConverter
          .orderBy('createdAt', descending: true)
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
      final doc = await _collectionRef.collectionConverter.doc(uidStr).get();
      final collection = doc.data()?.toDomain();
      if (collection == null) return const Left(NoCollectionFoundException());
      return Right(collection);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }
}
