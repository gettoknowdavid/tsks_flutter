import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CheckMark extends StatelessWidget {
  const CheckMark({
    required this.color,
    this.dimension = 16,
    this.borderRadius = const BorderRadiusGeometry.all(Radius.circular(16)),
    super.key,
  });

  final Color? color;
  final double dimension;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Skeleton.shade(
      child: Container(
        decoration: BoxDecoration(
          color: color?.withValues(alpha: 0.5),
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Container(
            height: dimension,
            width: dimension,
            decoration: BoxDecoration(color: color, borderRadius: borderRadius),
            child: const Icon(Icons.check, size: 13),
          ),
        ),
      ),
    );
  }
}
