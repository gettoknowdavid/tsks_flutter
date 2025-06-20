import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/dtos/timestamp_converter.dart';
import 'package:tsks_flutter/data/dtos/todos/todo_dto.dart';
import 'package:tsks_flutter/data/services/cloud_firestore.dart';
import 'package:tsks_flutter/domain/core/exceptions/exceptions.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';
import 'package:tsks_flutter/ui/auth/providers/session/session.dart';

part 'todos_repository.g.dart';

@riverpod
TodosRepository todosRepository(Ref ref) {
  final firestore = ref.read(firestoreProvider);
  final userDocumentReference = ref.read(userDocumentReferenceProvider);

  return TodosRepository(
    firestore: firestore,
    userDocumentReference: userDocumentReference,
  );
}

final class TodosRepository {
  const TodosRepository({
    required FirebaseFirestore firestore,
    required DocumentReference<User> userDocumentReference,
  }) : _firestore = firestore,
       _userDocumentReference = userDocumentReference;

  final FirebaseFirestore _firestore;
  final DocumentReference<User> _userDocumentReference;

  CollectionReference<Map<String, dynamic>> _todoReference(Uid collectionUid) {
    return _userDocumentReference
        .collection('collections')
        .doc(collectionUid.getOrCrash)
        .collection('todos');
  }

  CollectionReference<Map<String, dynamic>> _subTodoReference({
    required Uid collectionUid,
    required Uid parentTodoUid,
  }) {
    return _userDocumentReference
        .collection('collections')
        .doc(collectionUid.getOrCrash)
        .collection('todos')
        .doc(parentTodoUid.getOrCrash)
        .collection('subTodos');
  }

  Future<Either<TsksException, Todo>> createTodo({
    required Uid collectionUid,
    required SingleLineString title,
    bool? isDone = false,
    DateTime? dueDate,
    Uid? parentTodoUid,
  }) async {
    try {
      final data = {
        'ownerUid': _userDocumentReference.id,
        'collectionUid': collectionUid.getOrCrash,
        'title': title.getOrCrash,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isDone': isDone,
        'dueDate': dueDate != null
            ? const TimestampConverter().toJson(dueDate)
            : null,
        'parentTodoUid': parentTodoUid?.getOrNull,
      };

      DocumentReference<Map<String, dynamic>> documentReference;

      if (parentTodoUid != null) {
        documentReference = await _subTodoReference(
          collectionUid: collectionUid,
          parentTodoUid: parentTodoUid,
        ).add(data);
      } else {
        documentReference = await _todoReference(collectionUid).add(data);
      }

      final snapshot = await documentReference.todoConverter.get();
      final todoDto = snapshot.data();

      if (todoDto == null) return const Left(NoTodoFoundException());
      return Right(todoDto.toDomain());
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Unit>> markTodo(Todo todo) async {
    try {
      final parentTodoUid = todo.parentTodoUid;
      final updatePayload = {
        'isDone': todo.isDone,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (parentTodoUid != null) {
        await _subTodoReference(
          collectionUid: todo.collectionUid,
          parentTodoUid: parentTodoUid,
        ).doc(todo.uid.getOrCrash).update(updatePayload);
      } else {
        await _todoReference(
          todo.collectionUid,
        ).doc(todo.uid.getOrCrash).update(updatePayload);
      }
      return const Right(unit);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Todo>> updateTodo({
    required Uid uid,
    required Uid collectionUid,
    required Map<String, dynamic> data,
    Uid? parentTodoUid,
  }) async {
    if (data.isEmpty) return const Left(NoTodoFoundException());

    try {
      final uidStr = uid.getOrCrash;
      DocumentReference<Map<String, dynamic>> documentReference;

      if (parentTodoUid == null) {
        documentReference = _todoReference(collectionUid).doc(uidStr);
      } else {
        documentReference = _subTodoReference(
          collectionUid: collectionUid,
          parentTodoUid: parentTodoUid,
        ).doc(uidStr);
      }

      await documentReference.update(data);
      final snapshot = await documentReference.todoConverter.get();
      final todoDto = snapshot.data();

      if (todoDto == null) {
        return const Left(TsksException('An error unknown occurred.'));
      }

      return Right(todoDto.toDomain());
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Unit>> deleteTodo(Todo todo) async {
    try {
      final todoUid = todo.uid.getOrCrash;
      final collectionUid = todo.collectionUid;
      final parentTodoUid = todo.parentTodoUid;
      if (parentTodoUid == null) {
        // Top-level todo: need to also delete its sub-collection
        await _firestore.runTransaction((transaction) async {
          final parentDocument = _todoReference(collectionUid).doc(todoUid);
          transaction.delete(parentDocument);

          // Delete all sub-todos within its sub-collection
          final subTodos = await parentDocument.collection('subTodos').get();
          for (final doc in subTodos.docs) {
            transaction.delete(doc.reference);
          }
        });
      } else {
        await _subTodoReference(
          collectionUid: collectionUid,
          parentTodoUid: parentTodoUid,
        ).doc(todoUid).delete();
      }
      return const Right(unit);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, List<Todo?>>> getTodos(
    Uid collectionUid,
  ) async {
    try {
      final querySnapshot = await _todoReference(
        collectionUid,
      ).todoConverter.orderBy('updatedAt', descending: true).get();

      final todos = querySnapshot.docs
          .map((snapshot) => snapshot.data()?.toDomain())
          .toList();

      return Right(todos);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, List<Todo?>>> getSubTodos({
    required Uid collectionUid,
    required Uid parentTodoUid,
  }) async {
    try {
      final querySnapshot = await _subTodoReference(
        collectionUid: collectionUid,
        parentTodoUid: parentTodoUid,
      ).todoConverter.get();

      final subTodos = querySnapshot.docs
          .map((snapshot) => snapshot.data()?.toDomain())
          .toList();

      return Right(subTodos);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  /// Moves a top-level todo to a different collection.
  Future<Either<TsksException, Todo>> moveTodoToCollection(
    Todo todo,
    Uid collectionUid,
  ) async {
    try {
      final todoUid = todo.uid.getOrCrash;
      // Define references to the old location
      final oldReference = _todoReference(todo.collectionUid).doc(todoUid);

      // Define references to the new location
      final newReference = _todoReference(collectionUid).doc(todoUid);

      // Create the new data object with the updated collection Uid.
      final newTodo = todo.copyWith(collectionUid: collectionUid);
      final newTodoData = TodoDto.fromDomain(newTodo).toJson();

      // Run the move as an atomic transaction.
      await _firestore.runTransaction((transaction) async {
        // We get the old doc first to ensure it still exists.
        final oldDocSnapshot = await transaction.get(oldReference);
        if (!oldDocSnapshot.exists) {
          throw const NoTodoFoundException();
        }

        // Create the new document and delete the old one.
        transaction.set(newReference, newTodoData);
        transaction.delete(oldReference);
      });

      return Right(newTodo);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  /// Moves a sub-todo to a different parent todo (and/or collection).
  Future<Either<TsksException, Unit>> moveSubTodo({
    required Todo subTodoToMove,
    required Uid newCollectionUid,
    required Uid newParentTodoUid,
  }) async {
    // Ensure the sub-todo being moved actually has a parent.
    if (subTodoToMove.parentTodoUid == null) {
      return const Left(TsksException('Cannot move a top-level todo.'));
    }

    try {
      // 1. Define references to the old and new locations.
      final oldDocRef = _subTodoReference(
        collectionUid: subTodoToMove.collectionUid,
        parentTodoUid: subTodoToMove.parentTodoUid!,
      ).doc(subTodoToMove.uid.getOrCrash);

      final newDocRef = _subTodoReference(
        collectionUid: newCollectionUid,
        parentTodoUid: newParentTodoUid,
      ).doc(subTodoToMove.uid.getOrCrash);

      // 2. Create the new data object with updated Uids.
      final newSubTodo = subTodoToMove.copyWith(
        collectionUid: newCollectionUid,
        parentTodoUid: newParentTodoUid,
      );

      final newSubTodoData = TodoDto.fromDomain(newSubTodo).toJson();

      // 3. Run the move as an atomic transaction.
      await _firestore.runTransaction((transaction) async {
        final oldDocSnapshot = await transaction.get(oldDocRef);
        if (!oldDocSnapshot.exists) {
          throw const NoTodoFoundException();
        }

        transaction.set(newDocRef, newSubTodoData);
        transaction.delete(oldDocRef);
      });

      return const Right(unit);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }
}
