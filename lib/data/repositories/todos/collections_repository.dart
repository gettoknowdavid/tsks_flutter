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

  Future<Either<TsksException, Unit>> createCollection({
    required Id id,
    required SingleLineString title,
    bool? isFavourite = false,
    int? colorARGB,
    Map<String, dynamic>? iconMap,
  }) async {
    try {
      await _collectionRef.doc(id.getOrCrash).set({
        'id': id.getOrCrash,
        'title': title.getOrCrash,
        'isFavourite': isFavourite,
        'colorARGB': colorARGB,
        'iconMap': iconMap,
      });
      return const Right(unit);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, List<Collection>>> getCollections() async {
    try {
      final querySnapshot = await _collectionRef.collectionConverter.get();
      final collections = querySnapshot.docs
          .map((snapshot) => snapshot.data().toDomain())
          .toList();
      return Right(collections);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }
}
