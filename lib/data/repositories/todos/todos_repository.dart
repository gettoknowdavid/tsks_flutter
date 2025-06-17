import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/services/cloud_firestore.dart';
import 'package:tsks_flutter/domain/core/exceptions/exceptions.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';
import 'package:tsks_flutter/ui/auth/providers/session/session.dart';

part 'todos_repository.g.dart';

@riverpod
TodosRepository todosRepository(Ref ref) {
  final userDocumentReference = ref.read(userDocumentReferenceProvider);
  return TodosRepository(userDocumentReference: userDocumentReference);
}

final class TodosRepository {
  const TodosRepository({
    required DocumentReference<User> userDocumentReference,
  }) : _userDocumentReference = userDocumentReference;

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
        .collection('sub-todos');
  }

  Future<Either<TsksException, Todo>> createTodo({
    required Uid collectionUid,
    required SingleLineString title,
    required DateTime createdAt,
    bool? isDone = false,
    DateTime? dueDate,
    DateTime? updatedAt,
    Uid? parentTodoUid,
  }) async {
    try {
      final data = {
        'collectionUid': collectionUid.getOrCrash,
        'title': title.getOrCrash,
        'createdAt': createdAt.toIso8601String(),
        'isDone': isDone,
        'dueDate': dueDate?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
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
      await _todoReference(
        todo.collectionUid,
      ).doc(todo.uid.getOrCrash).update({'isDone': todo.isDone});
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
  }) async {
    if (data.isEmpty) return const Left(NoTodoFoundException());

    try {
      final documentReference = _todoReference(
        collectionUid,
      ).doc(uid.getOrCrash);

      await _todoReference(collectionUid).doc(uid.getOrCrash).update(data);

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

  Future<Either<TsksException, Unit>> deleteTodo({
    required Uid todoUid,
    required Uid collectionUid,
  }) async {
    try {
      await _todoReference(collectionUid).doc(todoUid.getOrCrash).delete();
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
      ).todoConverter.get();

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
}
