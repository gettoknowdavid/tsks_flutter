import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/data/dtos/timestamp_converter.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';

final class CollectionDto with EquatableMixin {
  const CollectionDto({
    required this.uid,
    required this.ownerUid,
    required this.title,
    required this.createdAt,
    this.isFavourite = false,
    this.colorARGB,
    this.iconMap,
    this.updatedAt,
  });

  factory CollectionDto.fromFirestore(String uid, Map<String, dynamic> json) {
    return CollectionDto(
      uid: uid,
      ownerUid: json['ownerUid'] as String,
      title: json['title'] as String,
      isFavourite: json['isFavourite'] as bool? ?? false,
      colorARGB: (json['colorARGB'] as num?)?.toInt(),
      iconMap: json['iconMap'] as Map<String, dynamic>?,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: json['updatedAt'] != null
          ? const TimestampConverter().fromJson(json['updatedAt'] as Timestamp)
          : null,
    );
  }

  factory CollectionDto.fromDomain(Collection collection) {
    return CollectionDto(
      uid: collection.uid.getOrCrash,
      ownerUid: collection.ownerUid.getOrCrash,
      title: collection.title.getOrCrash,
      isFavourite: collection.isFavourite,
      colorARGB: collection.colorARGB,
      iconMap: collection.iconMap,
      createdAt: collection.createdAt,
      updatedAt: collection.updatedAt,
    );
  }

  final String uid;
  final String ownerUid;
  final String title;
  final bool isFavourite;
  final int? colorARGB;
  final Map<String, dynamic>? iconMap;
  final DateTime createdAt;
  final DateTime? updatedAt;

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

  Map<String, dynamic> toJson() => <String, dynamic>{
    'uid': uid,
    'ownerUid': ownerUid,
    'title': title,
    'isFavourite': isFavourite,
    'colorARGB': colorARGB,
    'iconMap': iconMap,
    'createdAt': const TimestampConverter().toJson(createdAt),
    'updatedAt': updatedAt != null
        ? const TimestampConverter().toJson(updatedAt!)
        : null,
  };

  Collection toDomain() {
    return Collection(
      uid: Uid(uid),
      ownerUid: Uid(ownerUid),
      title: SingleLineString(title),
      isFavourite: isFavourite,
      colorARGB: colorARGB,
      iconMap: iconMap,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  CollectionDto copyWith({
    String? uid,
    String? ownerUid,
    String? title,
    bool? isFavourite,
    int? colorARGB,
    Map<String, dynamic>? iconMap,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CollectionDto(
      uid: uid ?? this.uid,
      ownerUid: ownerUid ?? this.ownerUid,
      title: title ?? this.title,
      isFavourite: isFavourite ?? this.isFavourite,
      colorARGB: colorARGB ?? this.colorARGB,
      iconMap: iconMap ?? this.iconMap,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
