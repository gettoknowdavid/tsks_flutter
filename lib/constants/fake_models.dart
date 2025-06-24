import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/models/tasks/task.dart';

final fakeCollection = Collection(
  id: '1',
  creator: '2',
  title: BoneMock.title,
  colorARGB: Colors.blue.toARGB32(),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

final List<Collection> fakeCollections = List.generate(
  3,
  (index) => Collection(
    id: '$index',
    creator: '2',
    title: BoneMock.title,
    colorARGB: Colors.blue.toARGB32(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
);

final List<Task> fakeTasks = List.generate(
  3,
  (index) => Task(
    id: '$index',
    title: BoneMock.title,
    collection: '3',
    assignee: '4',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    dueDate: DateTime.now(),
  ),
);
