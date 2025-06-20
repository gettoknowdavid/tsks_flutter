import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/ui/todos/providers/collection_todos_count.dart';
import 'package:tsks_flutter/ui/todos/widgets/check_mark.dart';
import 'package:tsks_flutter/utils/utils.dart';

class CollectionTasksStatusWidget extends ConsumerWidget {
  const CollectionTasksStatusWidget({required this.collection, super.key});

  final Collection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accentColor = collection.colorARGB?.toColor;
    final effectiveAccentColor = accentColor ?? theme.colorScheme.secondary;

    final uid = collection.uid;
    final totalTodosAsync = ref.watch(collectionTodosCountProvider(uid));
    final doneTodosAsync = ref.watch(collectionDoneTodosCountProvider(uid));

    final totalTodos = totalTodosAsync.value ?? 0;
    final doneTodos = doneTodosAsync.value ?? 0;

    final ratio = totalTodos > 0
        ? computeTasksRatio(doneTodos, totalTodos)
        : 0.0;

    final isLoading = totalTodosAsync.isLoading || doneTodosAsync.isLoading;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Skeletonizer(
          enabled: isLoading,
          child: Text(
            totalTodos < 1 ? 'No todos' : '$doneTodos/$totalTodos done',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        Skeletonizer(
          enabled: isLoading,
          child: SizedBox.square(
            dimension: 24,
            child: ratio == 1.0 && totalTodos > 0
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
