import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';

final class TodoDto with EquatableMixin {
  const TodoDto({
    required this.uid,
    required this.collectionUid,
    required this.title,
    required this.createdAt,
    this.isDone = false,
    this.dueDate,
    this.updatedAt,
  });

  factory TodoDto.fromFirestore(String uid, Map<String, dynamic> json) {
    return TodoDto(
      uid: uid,
      collectionUid: json['collectionUid'] as String,
      title: json['title'] as String,
      isDone: json['isDone'] as bool? ?? false,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  factory TodoDto.fromDomain(Todo todo) {
    return TodoDto(
      uid: todo.uid.getOrCrash,
      collectionUid: todo.collectionUid.getOrCrash,
      title: todo.title.getOrCrash,
      isDone: todo.isDone,
      dueDate: todo.dueDate,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
    );
  }

  final String uid;
  final String collectionUid;
  final String title;
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

  Map<String, dynamic> toJson() => <String, dynamic>{
    'uid': uid,
    'title': title,
    'isDone': isDone,
    'dueDate': dueDate?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'collectionUid': collectionUid,
  };

  Todo toDomain() {
    return Todo(
      uid: Uid(uid),
      collectionUid: Uid(collectionUid),
      title: SingleLineString(title),
      isDone: isDone,
      dueDate: dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  TodoDto copyWith({
    String? uid,
    String? title,
    bool? isDone,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? collectionUid,
  }) {
    return TodoDto(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      collectionUid: collectionUid ?? this.collectionUid,
    );
  }
}
