import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';

final class Todo with EquatableMixin {
  const Todo({
    required this.uid,
    required this.title,
    this.isDone = false,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
    this.collectionUid,
  });

  static Todo empty = Todo(uid: Uid(''), title: SingleLineString(''));

  final Uid uid;
  final SingleLineString title;
  final bool isDone;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Uid? collectionUid;

  @override
  List<Object?> get props => [
    uid,
    title,
    isDone,
    dueDate,
    createdAt,
    updatedAt,
    collectionUid,
  ];
}
