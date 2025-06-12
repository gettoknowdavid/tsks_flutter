import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/utils/color_to_int_extension.dart';

class CollectionIconWidget extends StatelessWidget {
  const CollectionIconWidget({
    required this.collection,
    super.key,
    this.size = 44,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  final Collection collection;
  final double size;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = collection.colorARGB?.toColor;

    // final iconMap = collection.iconMap;
    // final icon = iconMap != null ? deserializeIcon(iconMap) : null;

    return Skeleton.leaf(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(color: color, borderRadius: borderRadius),
        child: IconTheme(
          data: IconThemeData(size: size * 0.7, color: colorScheme.onSurface),
          child: const Icon(PhosphorIconsBold.snowflake),
        ),
      ),
    );
  }
}
