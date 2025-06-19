import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';

final fakeCollection = Collection(
  uid: Uid('1'),
  ownerUid: Uid(''),
  title: SingleLineString(BoneMock.title),
  colorARGB: Colors.blue.toARGB32(),
  createdAt: DateTime.now(),
);

final List<Collection> fakeCollections = List.generate(
  3,
  (index) => Collection(
    uid: Uid(index.toString()),
    ownerUid: Uid(''),
    title: SingleLineString(BoneMock.title),
    colorARGB: Colors.blue.toARGB32(),
    createdAt: DateTime.now(),
  ),
);

final List<Todo> fakeTodos = List.generate(
  3,
  (index) => Todo(
    uid: Uid(index.toString()),
    ownerUid: Uid(''),
    collectionUid: Uid(''),
    title: SingleLineString(BoneMock.title),
    createdAt: DateTime.now(),
    dueDate: DateTime.now(),
  ),
);
