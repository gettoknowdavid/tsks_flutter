import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:tsks_flutter/models/auth/user.dart' show User;
import 'package:tsks_flutter/models/timestamp_converter.dart';

final class Collection with EquatableMixin {
  const Collection({
    required this.id,
    required this.creator,
    required this.title,
    required this.createdAt,
    this.isFavourite = false,
    this.colorARGB,
    this.iconMap,
    this.updatedAt,
  });

  factory Collection.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data()!;
    return Collection(
      id: doc.id,
      creator: json['creator'] as String,
      title: json['title'] as String,
      isFavourite: json['isFavourite'] as bool? ?? false,
      colorARGB: (json['colorARGB'] as num?)?.toInt(),
      iconMap: json['iconMap'] as Map<String, dynamic>?,
      createdAt: TimestampConverter.fromFirestore(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: json['updatedAt'] != null
          ? TimestampConverter.fromFirestore(json['updatedAt'] as Timestamp)
          : null,
    );
  }

  Map<String, dynamic> toFirestore({String? creator}) {
    return {
      'creator': creator ?? this.creator,
      'title': title,
      'isFavourite': isFavourite,
      'colorARGB': colorARGB,
      'iconMap': iconMap,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// ID of the collection
  final String id;

  /// The ID of the [User] who created the collection
  final String creator;

  /// The title of the collection
  final String title;

  /// Whether the collection is filtered as favourite.
  ///
  /// Defaults to `false`.
  final bool isFavourite;

  /// The accent color of the collection.
  ///
  /// This value is converted to ARGB integer using the [Color.toARGB32]
  /// extension.
  final int? colorARGB;

  /// Stores an [IconData] of the selected collection icon
  final Map<String, dynamic>? iconMap;

  /// Time of creation
  final DateTime createdAt;

  /// Time of udpate
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    creator,
    title,
    isFavourite,
    colorARGB,
    iconMap,
    createdAt,
    updatedAt,
  ];

  Collection copyWith({
    String? creator,
    String? title,
    bool? isFavourite,
    int? colorARGB,
    Map<String, dynamic>? iconMap,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Collection(
      id: id,
      creator: creator ?? this.creator,
      title: title ?? this.title,
      isFavourite: isFavourite ?? this.isFavourite,
      colorARGB: colorARGB ?? this.colorARGB,
      iconMap: iconMap ?? this.iconMap,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Map<String, dynamic Function(Collection)> schema = {
    'creator': (Collection c) => c.creator,
    'title': (Collection c) => c.title,
    'isFavourite': (Collection c) => c.isFavourite,
    'colorARGB': (Collection c) => c.colorARGB,
    'iconMap': (Collection c) => c.iconMap,
  };

  static Set<String> deepCompareFields = {'iconMap', 'collaborators'};
}
