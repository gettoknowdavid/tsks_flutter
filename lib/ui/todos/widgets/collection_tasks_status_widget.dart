import 'package:flutter/material.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/ui/todos/widgets/check_mark.dart';
import 'package:tsks_flutter/utils/utils.dart';

class CollectionTasksStatusWidget extends StatelessWidget {
  const CollectionTasksStatusWidget({required this.collection, super.key});
  final Collection collection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = collection.colorARGB?.toColor;
    final effectiveAccentColor = accentColor ?? theme.colorScheme.secondary;

    const doneTasks = 2;
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
