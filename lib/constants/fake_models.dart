import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:uuid/uuid.dart';

final fakeCollection = Collection(
  id: Id.fromString(const Uuid().v4()),
  title: SingleLineString(BoneMock.title),
  colorARGB: Colors.blue.toARGB32(),
  createdAt: DateTime.now(),
);

final List<Collection> fakeCollections = List.generate(
  3,
  (index) => fakeCollection,
);
