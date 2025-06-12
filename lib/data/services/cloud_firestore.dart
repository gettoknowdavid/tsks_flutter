import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/dtos/auth/user_dto.dart';
import 'package:tsks_flutter/data/dtos/todos/collection_dto.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';

part 'cloud_firestore.g.dart';

@riverpod
FirebaseFirestore firestore(Ref ref) => FirebaseFirestore.instance;

extension DocumentSnapshotX on DocumentSnapshot {
  CollectionDto? get firestoreToCollectionDto {
    final json = data() as Map<String, dynamic>?;
    return json == null ? null : CollectionDto.fromJson(json);
  }
}

extension CollectionReferenceX on CollectionReference {
  CollectionReference<User> get userConverter {
    return withConverter<User>(
      fromFirestore: (s, _) => UserDto.fromJson(s.data()!).toDomain(),
      toFirestore: (value, _) => UserDto.fromDomain(value).toJson(),
    );
  }

  CollectionReference<CollectionDto> get collectionConverter {
    return withConverter<CollectionDto>(
      fromFirestore: (s, _) => CollectionDto.fromJson(s.data()!),
      toFirestore: (value, _) => value.toJson(),
    );
  }
}
