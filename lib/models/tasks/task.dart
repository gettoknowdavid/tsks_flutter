import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/models/collections/collection.dart'
    show Collection;
import 'package:tsks_flutter/models/timestamp_converter.dart';

final class Task with EquatableMixin {
  const Task({
    required this.id,
    required this.collection,
    required this.title,
    required this.createdAt,
    this.isDone = false,
    this.dueDate,
    this.updatedAt,
    this.parentTask,
    this.assignee,
  });

  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data()!;
    return Task(
      id: doc.id,
      collection: json['collection'] as String,
      title: json['title'] as String,
      isDone: json['isDone'] as bool? ?? false,
      dueDate: json['dueDate'] != null
          ? TimestampConverter.fromFirestore(json['dueDate'] as Timestamp)
          : null,
      parentTask: json['parentTask'] != null
          ? json['parentTask'] as String
          : null,
      assignee: json['assignee'] != null ? json['assignee'] as String : null,
      createdAt: TimestampConverter.fromFirestore(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: json['updatedAt'] != null
          ? TimestampConverter.fromFirestore(json['updatedAt'] as Timestamp)
          : null,
    );
  }

  Map<String, dynamic> toFirestore() => <String, dynamic>{
    'collection': collection,
    'title': title,
    'isDone': isDone,
    'dueDate': dueDate != null
        ? TimestampConverter.toFirestore(dueDate!)
        : null,
    'parentTask': parentTask,
    'assignee': assignee,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };

  /// ID of task
  final String id;

  /// ID of the [Collection] to which the task belongs to
  final String collection;

  /// The title of the task
  final String title;

  /// Whether the task is completed or not.
  ///
  /// Defaults to `false`
  final bool isDone;

  /// Date and time the task is due to be completed
  final DateTime? dueDate;

  /// Time the task object was created
  final DateTime createdAt;

  /// Time the task object was updated
  final DateTime? updatedAt;

  /// ID of the a parent task, making this current task a sub-task
  final String? parentTask;

  /// ID of the user the task is assigned to, if any
  final String? assignee;

  @override
  List<Object?> get props => [
    id,
    collection,
    title,
    isDone,
    dueDate,
    createdAt,
    updatedAt,
    parentTask,
    assignee,
  ];

  Task copyWith({
    String? collection,
    String? title,
    bool? isDone,
    DateTime? dueDate,
    String? parentTask,
    String? assignee,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id,
      collection: collection ?? this.collection,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
      parentTask: parentTask ?? this.parentTask,
      assignee: assignee ?? this.assignee,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Map<String, dynamic Function(Task)> schema = {
    'collection': (Task t) => t.collection,
    'title': (Task t) => t.title,
    'isDone': (Task t) => t.isDone,
    'dueDate': (Task t) => t.dueDate,
    'parentTask': (Task t) => t.parentTask,
    'assignee': (Task t) => t.assignee,
  };

  static Set<String> deepCompareFields = {};
}
