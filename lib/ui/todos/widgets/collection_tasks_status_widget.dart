import 'package:flutter/material.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/utils/utils.dart';

class CollectionTasksStatusWidget extends StatelessWidget {
  const CollectionTasksStatusWidget({required this.collection, super.key});
  final Collection collection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = collection.colorARGB?.toColor;
    final effectiveAccentColor = accentColor ?? theme.colorScheme.secondary;

    const doneTasks = 1;
    const totalTasks = 2;
    final ratio = computeTasksRatio(doneTasks, totalTasks);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$doneTasks/$totalTasks done',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        SizedBox.square(
          dimension: 24,
          child: ratio == 1
              ? CheckMark(color: effectiveAccentColor)
              : CircularProgressIndicator(
                  value: ratio,
                  color: effectiveAccentColor,
                  strokeAlign: -1,
                ),
        ),
      ],
    );
  }
}

class CheckMark extends StatelessWidget {
  const CheckMark({required this.color, super.key});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color?.withValues(alpha: 0.5),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 8,
        child: const Icon(Icons.check, size: 13),
      ),
    );
  }
}
