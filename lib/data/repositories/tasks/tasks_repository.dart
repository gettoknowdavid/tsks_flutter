import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart' hide Task;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/data/repositories/collections/collections_repository.dart';
import 'package:tsks_flutter/data/services/cloud_firestore.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/models/timestamp_converter.dart';
import 'package:tsks_flutter/utils/get_model_difference.dart';

part 'tasks_repository.g.dart';

@riverpod
TasksRepository tasksRepository(Ref ref) {
  final firestore = ref.read(firestoreProvider);
  final collectionReference = ref.read(collectionReferenceProvider);
  return TasksRepository(
    firestore: firestore,
    collectionReference: collectionReference,
  );
}

final class TasksRepository {
  const TasksRepository({
    required FirebaseFirestore firestore,
    required CollectionReference<Map<String, dynamic>> collectionReference,
  }) : _firestore = firestore,
       _collectionReference = collectionReference;

  final FirebaseFirestore _firestore;
  final CollectionReference<Map<String, dynamic>> _collectionReference;

  CollectionReference<Map<String, dynamic>> _taskReference(String collection) {
    return _collectionReference.doc(collection).collection('tasks');
  }

  Future<Either<TsksException, Task>> createTask({
    required String collection,
    required String title,
    bool? isDone = false,
    DateTime? dueDate,
    String? parentTask,
    String? assignee,
  }) async {
    try {
      final documentReference = await _taskReference(collection).add({
        'collection': collection,
        'title': title,
        'isDone': isDone,
        'parentTask': parentTask,
        'assignee': assignee,
        'dueDate': dueDate != null
            ? TimestampConverter.toFirestore(dueDate)
            : null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final snapshot = await documentReference.taskConverter.get();
      final result = snapshot.data();
      if (result == null) return const Left(NoCollectionFoundException());

      return Right(result);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Unit>> deleteTask(Task task) async {
    try {
      final taskId = task.id;
      final collectionId = task.collection;
      if (task.parentTask == null) {
        // Top-level task: need to also delete its sub-collection
        await _firestore.runTransaction((transaction) async {
          final parentTaskReference = _taskReference(collectionId).doc(taskId);

          // Delete the top-level task itself
          transaction.delete(parentTaskReference);

          //  Find and delete all sub-tasks that belong to this top-level task
          //  We query the same 'tasks' collection for documents where
          //  'parentTask' matches the top-level task's UID.
          final subTasksSnapshot = await _taskReference(
            collectionId,
          ).where('parentTask', isEqualTo: taskId).get();

          for (final doc in subTasksSnapshot.docs) {
            transaction.delete(doc.reference);
          }
        });
      } else {
        // This is a sub-task: Just delete this single task.
        await _taskReference(collectionId).doc(taskId).delete();
      }
      return const Right(unit);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, int>> getNumberOfTasks(
    String collection, {
    bool? isDone,
  }) async {
    try {
      AggregateQuery aggregateQuery;

      if (isDone == null) {
        aggregateQuery = _taskReference(collection).count();
      } else {
        aggregateQuery = _taskReference(
          collection,
        ).where('isDone', isEqualTo: isDone).count();
      }

      final countQuery = await aggregateQuery.get();
      return Right(countQuery.count ?? 0);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, List<Task?>>> getSubTasks({
    required String collection,
    required String parentTask,
    int limit = 10,
    DocumentSnapshot<Map<String, dynamic>>? startAfterDocument,
  }) async {
    try {
      var query = _taskReference(collection).taskConverter
          .where('parentTask', isEqualTo: parentTask)
          .orderBy('updatedAt', descending: true)
          .limit(limit);

      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      final querySnapshot = await query.get();
      final tasks = querySnapshot.docs.map((s) => s.data()).toList();
      return Right(tasks);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, List<Task?>>> getTopLevelTasks(
    String collection, {
    int limit = 10,
    DocumentSnapshot<Map<String, dynamic>>? startAfterDocument,
    bool? isDone,
  }) async {
    try {
      Query<Task?> query;

      if (isDone == null) {
        query = _taskReference(collection).taskConverter
            .where('parentTask', isNull: true)
            .orderBy('updatedAt', descending: true)
            .limit(limit);
      } else {
        query = _taskReference(collection).taskConverter
            .where('parentTask', isNull: true)
            .where('isDone', isEqualTo: isDone)
            .orderBy('updatedAt', descending: true)
            .limit(limit);
      }

      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      final querySnapshot = await query.get();
      final tasks = querySnapshot.docs.map((s) => s.data()).toList();
      return Right(tasks);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      log(e.toString());
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Task>> moveTaskToCollection(
    Task task,
    String collection,
  ) async {
    try {
      final taskId = task.id;

      // Define references to the old location
      final oldReference = _taskReference(task.collection).doc(taskId);

      // Define references to the new location
      final newReference = _taskReference(collection).doc(taskId);

      // Create the new data object with the updated collection Uid.
      final newTask = task.copyWith(collection: collection);

      // Run the move as an atomic transaction.
      await _firestore.runTransaction((transaction) async {
        // We get the old doc first to ensure it still exists.
        final oldDocSnapshot = await transaction.get(oldReference);
        if (!oldDocSnapshot.exists) {
          throw const NoTaskFoundException();
        }

        // Create the new document and delete the old one.
        transaction.set(newReference, newTask.toFirestore());
        transaction.delete(oldReference);
      });

      return Right(newTask);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Unit>> toggleIsDone(Task task) async {
    try {
      final updatedTask = task.copyWith(isDone: !task.isDone);
      final data = getModelDifference<Task>(
        task,
        updatedTask,
        Task.schema,
        deepCompare: Task.deepCompareFields,
      );

      data['updatedAt'] = FieldValue.serverTimestamp();
      log('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      log('ORIGINAL TASK => $task');
      log('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      log('UPDATED TASK => $updatedTask');
      log('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      log('UPDATED TASK DATA => $data');
      log('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      await _taskReference(task.collection).doc(task.id).update(data);

      return const Right(unit);
    } on TimeoutException {
      return const Left(TsksTimeoutException());
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }

  Future<Either<TsksException, Task>> updateTask({
    required Task originalTask,
    required Task updatedTask,
  }) async {
    try {
      final data = getModelDifference<Task>(
        originalTask,
        updatedTask,
        Task.schema,
        deepCompare: Task.deepCompareFields,
      );

      // Always update 'updatedAt' for any change
      data['updatedAt'] = FieldValue.serverTimestamp();

      // Only send update if there are actual changes excluding `updatedAt`
      if (data.length == 1 && data.containsKey('updatedAt')) {
        return const Left(NoCollectionFoundException());
      }

      final collection = updatedTask.collection;
      final documentReference = _taskReference(collection).doc(updatedTask.id);
      await documentReference.update(data);

      final snapshot = await documentReference.taskConverter.get();
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

extension TasksCollectionReferenceX on CollectionReference {
  CollectionReference<Task?> get taskConverter {
    return withConverter<Task>(
      fromFirestore: (snapshot, _) => Task.fromFirestore(snapshot),
      toFirestore: (model, _) => model.toFirestore(),
    );
  }
}

extension TasksDocumentReferenceX on DocumentReference {
  DocumentReference<Task?> get taskConverter {
    return withConverter<Task>(
      fromFirestore: (snapshot, _) => Task.fromFirestore(snapshot),
      toFirestore: (model, _) => model.toFirestore(),
    );
  }
}
