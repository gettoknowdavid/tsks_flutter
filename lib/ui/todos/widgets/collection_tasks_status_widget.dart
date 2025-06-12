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

    const doneTasks = 0;
    const totalTasks = 0;
    final ratio = computeTasksRatio(doneTasks, totalTasks);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$doneTasks/$totalTasks done',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox.square(
          dimension: 24,
          child: ratio == 1
              ? CheckMark(color: accentColor)
              : CircularProgressIndicator(
                  value: ratio,
                  color: accentColor,
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
      backgroundColor: color?.withValues(alpha: 0.55),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 8,
        child: const Icon(Icons.check, size: 14),
      ),
    );
  }
}
