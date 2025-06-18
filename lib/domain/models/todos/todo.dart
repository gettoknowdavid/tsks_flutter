import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';

final class Todo with EquatableMixin {
  const Todo({
    required this.uid,
    required this.ownerUid,
    required this.collectionUid,
    required this.title,
    required this.createdAt,
    this.isDone = false,
    this.dueDate,
    this.updatedAt,
    this.parentTodoUid,
  });

  static Todo empty = Todo(
    uid: Uid(''),
    ownerUid: Uid(''),
    collectionUid: Uid(''),
    title: SingleLineString(''),
    createdAt: DateTime.now(),
  );

  final Uid uid;
  final Uid ownerUid;
  final Uid collectionUid;
  final SingleLineString title;
  final bool isDone;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Uid? parentTodoUid;

  Todo copyWith({
    Uid? uid,
    Uid? ownerUid,
    Uid? collectionUid,
    SingleLineString? title,
    bool? isDone,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Uid? parentTodoUid,
  }) {
    return Todo(
      uid: uid ?? this.uid,
      ownerUid: ownerUid ?? this.ownerUid,
      collectionUid: collectionUid ?? this.collectionUid,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      parentTodoUid: parentTodoUid ?? this.parentTodoUid,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    ownerUid,
    collectionUid,
    title,
    isDone,
    dueDate,
    createdAt,
    updatedAt,
  ];
}
