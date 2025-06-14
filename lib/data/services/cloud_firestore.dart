import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/dtos/auth/user_dto.dart';
import 'package:tsks_flutter/data/dtos/todos/collection_dto.dart';
import 'package:tsks_flutter/data/dtos/todos/todo_dto.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';

part 'cloud_firestore.g.dart';

@riverpod
FirebaseFirestore firestore(Ref ref) => FirebaseFirestore.instance;

extension DocumentSnapshotX on DocumentSnapshot {}

extension CollectionReferenceX on CollectionReference {
  CollectionReference<User> get userConverter {
    return withConverter<User>(
      fromFirestore: (s, _) => UserDto.fromJson(s.data()!).toDomain(),
      toFirestore: (value, _) => UserDto.fromDomain(value).toJson(),
    );
  }

  CollectionReference<CollectionDto?> get collectionConverter {
    return withConverter<CollectionDto>(
      fromFirestore: (s, _) => CollectionDto.fromFirestore(s.id, s.data()!),
      toFirestore: (value, _) => value.toJson(),
    );
  }

  CollectionReference<TodoDto?> get todoConverter {
    return withConverter<TodoDto>(
      fromFirestore: (s, _) => TodoDto.fromFirestore(s.id, s.data()!),
      toFirestore: (value, _) => value.toJson(),
    );
  }
}

extension DocumentReferenceX on DocumentReference {
  DocumentReference<CollectionDto?> get collectionConverter {
    return withConverter<CollectionDto>(
      fromFirestore: (s, _) => CollectionDto.fromFirestore(s.id, s.data()!),
      toFirestore: (value, _) => value.toJson(),
    );
  }

  DocumentReference<TodoDto?> get todoConverter {
    return withConverter<TodoDto>(
      fromFirestore: (s, _) => TodoDto.fromFirestore(s.id, s.data()!),
      toFirestore: (value, _) => value.toJson(),
    );
  }
}
