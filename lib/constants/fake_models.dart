import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';

final fakeCollection = Collection(
  uid: Uid('1'),
  title: SingleLineString(BoneMock.title),
  colorARGB: Colors.blue.toARGB32(),
  createdAt: DateTime.now(),
);

final List<Collection> fakeCollections = List.generate(
  3,
  (index) => Collection(
    uid: Uid(index.toString()),
    title: SingleLineString(BoneMock.title),
    colorARGB: Colors.blue.toARGB32(),
    createdAt: DateTime.now(),
  ),
);
