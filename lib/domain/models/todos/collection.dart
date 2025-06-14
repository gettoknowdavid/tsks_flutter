import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';

final class Collection with EquatableMixin {
  const Collection({
    required this.uid,
    required this.title,
    required this.createdAt,
    this.isFavourite = false,
    this.colorARGB,
    this.iconMap,
  });

  final Uid uid;
  final SingleLineString title;
  final bool isFavourite;
  final int? colorARGB;
  final Map<String, dynamic>? iconMap;
  final DateTime createdAt;

  static Collection empty = Collection(
    uid: Uid(''),
    title: SingleLineString(''),
    createdAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
    uid,
    title,
    isFavourite,
    colorARGB,
    iconMap,
    createdAt,
  ];
}
