import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';

part 'collection_dto.g.dart';

@JsonSerializable()
final class CollectionDto with EquatableMixin {
  const CollectionDto({
    required this.uid,
    required this.title,
    this.isFavourite = false,
    this.colorARGB,
    this.iconMap,
    this.createdAt,
  });

  factory CollectionDto.fromJson(Map<String, dynamic> json) =>
      _$CollectionDtoFromJson(json);

  factory CollectionDto.fromDomain(Collection collection) {
    return CollectionDto(
      uid: collection.uid.getOrCrash,
      title: collection.title.getOrCrash,
      isFavourite: collection.isFavourite,
      colorARGB: collection.colorARGB,
      iconMap: collection.iconMap,
      createdAt: collection.createdAt,
    );
  }

  final String uid;
  final String title;
  final bool isFavourite;
  final int? colorARGB;
  final Map<String, dynamic>? iconMap;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
    uid,
    title,
    isFavourite,
    colorARGB,
    iconMap,
    createdAt,
  ];
  Map<String, dynamic> toJson() => _$CollectionDtoToJson(this);

  Collection toDomain() {
    return Collection(
      uid: Uid(uid),
      title: SingleLineString(title),
      isFavourite: isFavourite,
      colorARGB: colorARGB,
      iconMap: iconMap,
      createdAt: createdAt,
    );
  }
}
