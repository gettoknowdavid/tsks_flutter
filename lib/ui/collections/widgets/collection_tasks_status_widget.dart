import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/ui/core/ui/check_mark.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_count_notifier.dart';
import 'package:tsks_flutter/utils/utils.dart';

class CollectionTasksStatusWidget extends ConsumerWidget {
  const CollectionTasksStatusWidget({required this.collection, super.key});

  final Collection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accentColor = collection.colorARGB?.toColor;
    final effectiveAccentColor = accentColor ?? theme.colorScheme.secondary;

    final id = collection.id;

    // Total task count
    final totalAsync = ref.watch(
      taskCountNotifierProvider(title: 'Total', collection: id),
    );

    // Done task count
    final doneAsync = ref.watch(
      taskCountNotifierProvider(title: 'Done', collection: id, isDone: true),
    );

    final totalTasks = totalAsync.value ?? 0;
    final doneTasks = doneAsync.value ?? 0;

    final ratio = computeTasksRatio(doneTasks, totalTasks);

    final isLoading = totalAsync.isLoading || doneAsync.isLoading;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Skeletonizer(
          enabled: isLoading,
          child: Text(
            totalTasks < 1 ? 'No todos' : '$doneTasks/$totalTasks done',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        Skeletonizer(
          enabled: isLoading,
          child: SizedBox.square(
            dimension: 24,
            child: totalTasks > 0 && ratio == 1.0
                ? CheckMark(color: effectiveAccentColor)
                : CircularProgressIndicator(
                    value: ratio,
                    color: effectiveAccentColor,
                    strokeAlign: -1,
                  ),
          ),
        ),
      ],
    );
  }
}
