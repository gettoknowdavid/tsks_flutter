import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';

final class CollectionDto with EquatableMixin {
  const CollectionDto({
    required this.uid,
    required this.title,
    required this.createdAt,
    this.isFavourite = false,
    this.colorARGB,
    this.iconMap,
  });

  factory CollectionDto.fromFirestore(String uid, Map<String, dynamic> json) {
    return CollectionDto(
      uid: uid,
      title: json['title'] as String,
      isFavourite: json['isFavourite'] as bool? ?? false,
      colorARGB: (json['colorARGB'] as num?)?.toInt(),
      iconMap: json['iconMap'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

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
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    uid,
    title,
    isFavourite,
    colorARGB,
    iconMap,
    createdAt,
  ];
  Map<String, dynamic> toJson() => <String, dynamic>{
    'uid': uid,
    'title': title,
    'isFavourite': isFavourite,
    'colorARGB': colorARGB,
    'iconMap': iconMap,
    'createdAt': createdAt.toIso8601String(),
  };

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

  CollectionDto copyWith({
    String? uid,
    String? title,
    bool? isFavourite,
    int? colorARGB,
    Map<String, dynamic>? iconMap,
    DateTime? createdAt,
  }) {
    return CollectionDto(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      isFavourite: isFavourite ?? this.isFavourite,
      colorARGB: colorARGB ?? this.colorARGB,
      iconMap: iconMap ?? this.iconMap,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
