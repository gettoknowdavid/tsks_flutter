import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/data/dtos/timestamp_converter.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';

final class TodoDto with EquatableMixin {
  const TodoDto({
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

  factory TodoDto.fromFirestore(String uid, Map<String, dynamic> json) {
    return TodoDto(
      uid: uid,
      ownerUid: json['ownerUid'] as String,
      collectionUid: json['collectionUid'] as String,
      title: json['title'] as String,
      isDone: json['isDone'] as bool? ?? false,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      dueDate: json['dueDate'] != null
          ? const TimestampConverter().fromJson(json['dueDate'] as Timestamp)
          : null,
      updatedAt: json['updatedAt'] != null
          ? const TimestampConverter().fromJson(json['updatedAt'] as Timestamp)
          : null,
      parentTodoUid: json['parentTodoUid'] != null
          ? json['parentTodoUid'] as String
          : null,
    );
  }

  factory TodoDto.fromDomain(Todo todo) {
    return TodoDto(
      uid: todo.uid.getOrCrash,
      ownerUid: todo.ownerUid.getOrCrash,
      collectionUid: todo.collectionUid.getOrCrash,
      title: todo.title.getOrCrash,
      isDone: todo.isDone,
      dueDate: todo.dueDate,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
      parentTodoUid: todo.parentTodoUid?.getOrNull,
    );
  }

  final String uid;
  final String ownerUid;
  final String collectionUid;
  final String title;
  final bool isDone;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? parentTodoUid;

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
    parentTodoUid,
  ];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'ownerUid': ownerUid,
    'collectionUid': collectionUid,
    'title': title,
    'isDone': isDone,
    'dueDate': dueDate != null
        ? const TimestampConverter().toJson(dueDate!)
        : null,
    'parentTodoUid': parentTodoUid,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };

  Todo toDomain() {
    return Todo(
      uid: Uid(uid),
      ownerUid: Uid(ownerUid),
      collectionUid: Uid(collectionUid),
      title: SingleLineString(title),
      isDone: isDone,
      dueDate: dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      parentTodoUid: parentTodoUid != null ? Uid(parentTodoUid!) : null,
    );
  }

  TodoDto copyWith({
    String? uid,
    String? title,
    bool? isDone,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerUid,
    String? collectionUid,
    String? parentTodoUid,
  }) {
    return TodoDto(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerUid: ownerUid ?? this.ownerUid,
      collectionUid: collectionUid ?? this.collectionUid,
      parentTodoUid: parentTodoUid ?? this.parentTodoUid,
    );
  }
}
