import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';

final class Todo with EquatableMixin {
  const Todo({
    required this.uid,
    required this.collectionUid,
    required this.title,
    required this.createdAt,
    this.isDone = false,
    this.dueDate,
    this.updatedAt,
  });

  static Todo empty = Todo(
    uid: Uid(''),
    collectionUid: Uid(''),
    title: SingleLineString(''),
    createdAt: DateTime.now(),
  );

  final Uid uid;
  final Uid collectionUid;
  final SingleLineString title;
  final bool isDone;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    uid,
    collectionUid,
    title,
    isDone,
    dueDate,
    createdAt,
    updatedAt,
  ];
}
