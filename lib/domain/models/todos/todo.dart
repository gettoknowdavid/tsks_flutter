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

  Todo copyWith({
    Uid? uid,
    Uid? collectionUid,
    SingleLineString? title,
    bool? isDone,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      uid: uid ?? this.uid,
      collectionUid: collectionUid ?? this.collectionUid,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
