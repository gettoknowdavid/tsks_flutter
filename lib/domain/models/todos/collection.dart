import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';

final class Collection with EquatableMixin {
  const Collection({
    required this.id,
    required this.title,
    this.isFavourite = false,
    this.colorARGB,
    this.iconMap,
    this.createdAt,
  });

  final Id id;
  final SingleLineString title;
  final bool isFavourite;
  final int? colorARGB;
  final Map<String, dynamic>? iconMap;
  final DateTime? createdAt;

  static Collection empty = Collection(
    id: Id.fromString(''),
    title: SingleLineString(''),
  );

  @override
  List<Object?> get props => [
    id,
    title,
    isFavourite,
    colorARGB,
    iconMap,
    createdAt,
  ];
}
