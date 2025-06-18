import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';

final class Collection with EquatableMixin {
  const Collection({
    required this.uid,
    required this.ownerUid,
    required this.title,
    required this.createdAt,
    this.isFavourite = false,
    this.colorARGB,
    this.iconMap,
    this.updatedAt,
  });

  final Uid uid;
  final Uid ownerUid;
  final SingleLineString title;
  final bool isFavourite;
  final int? colorARGB;
  final Map<String, dynamic>? iconMap;
  final DateTime createdAt;
  final DateTime? updatedAt;

  static Collection empty = Collection(
    uid: Uid(''),
    ownerUid: Uid(''),
    title: SingleLineString(''),
    createdAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
    uid,
    ownerUid,
    title,
    isFavourite,
    colorARGB,
    iconMap,
    createdAt,
    updatedAt,
  ];
}
