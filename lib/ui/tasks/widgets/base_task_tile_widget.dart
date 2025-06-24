import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/ui/tasks/providers/sub_task_count_notifier.dart';
import 'package:tsks_flutter/ui/tasks/providers/sub_tasks_notifier.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_form/task_form_notifier.dart';
import 'package:tsks_flutter/ui/tasks/providers/tasks_notifier.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_extensions.dart';

class BaseTaskTileWidget extends ConsumerWidget {
  const BaseTaskTileWidget({
    required this.task,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 12),
    super.key,
    this.trailing,
    this.onSecondaryTapDown,
    this.onLongPress,
  });

  final Task task;
  final EdgeInsetsGeometry padding;
  final Widget? trailing;
  final void Function(TapDownDetails)? onSecondaryTapDown;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = task.collection;
    final tasksNotifier = ref.read(tasksNotifierProvider(collection).notifier);
    final taskFormNotifier = ref.read(taskFormNotifierProvider.notifier);

    return Dismissible(
      key: ValueKey<String>(task.id),
      background: const _DismissedContainer(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => switch (direction) {
        DismissDirection.endToStart => tasksNotifier.deleteTask(task),
        _ => null,
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return context.showConfirmationDialog(
            title: 'Delete Task?',
            description: 'This action cannot be undone.',
          );
        }

        return null;
      },
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        onSecondaryTapDown: onSecondaryTapDown,
        onLongPress: onLongPress,
        onTap: () {
          taskFormNotifier.initializeWithTask(task);
          context.openTaskEditor();
        },
        child: Card(
          child: Padding(
            padding: padding,
            child: Column(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  spacing: 12,
                  children: [
                    if (task.parentTask == null)
                      _TaskCheckboxWidget(task: task),
                    Expanded(child: _TaskTitleWidget(task: task)),
                    trailing ?? const SizedBox.shrink(),
                  ],
                ),
                _TaskSubtitleWidget(task: task),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCheckboxWidget extends ConsumerWidget {
  const _TaskCheckboxWidget({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = task.id;
    final cId = task.collection;
    return Skeleton.shade(
      child: Transform.scale(
        scale: 1.4,
        child: SizedBox.square(
          dimension: 24,
          child: Checkbox(
            value: task.isDone,
            onChanged: (value) {
              if (task.parentTask == null) {
                final notifier = ref.read(tasksNotifierProvider(cId).notifier);
                notifier.isTaskChanged(task);
              } else {
                final notifier = ref.read(
                  subTasksNotifierProvider(
                    parentTask: id,
                    collection: cId,
                  ).notifier,
                );
                notifier.isTaskChanged(task);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _TaskTitleWidget extends StatelessWidget {
  const _TaskTitleWidget({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      task.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: theme.colorScheme.onSurfaceVariant,
        decoration: task.isDone ? TextDecoration.lineThrough : null,
      ),
    );
  }
}

class _TaskSubtitleWidget extends StatelessWidget {
  const _TaskSubtitleWidget({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 8, 0),
      child: Row(
        spacing: 16,
        children: [
          _SubTaskCountWidget(task, key: const Key('TaskSubTaskCountWidget')),
          _TaskDueDateWidget(task, key: const Key('TaskDueDateWidget')),
        ],
      ),
    );
  }
}

class _SubTaskCountWidget extends ConsumerWidget {
  const _SubTaskCountWidget(this.task, {super.key});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = task.collection;
    final parentTask = task.id;

    if (task.parentTask != null) return const SizedBox.shrink();

    // Total sub-tasks count
    final totalAsync = ref.watch(
      subTaskCountNotifierProvider(
        collection: collection,
        parentTask: parentTask,
        title: 'Total',
      ),
    );

    // Done sub-task count
    final doneAsync = ref.watch(
      subTaskCountNotifierProvider(
        collection: collection,
        parentTask: parentTask,
        title: 'Done',
        isDone: true,
      ),
    );

    final isLoading = totalAsync.isLoading || doneAsync.isLoading;

    final totalSubTasks = totalAsync.value ?? 0;
    final doneSubTasks = doneAsync.value ?? 0;

    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: isLoading,
      child: Row(
        spacing: 4,
        children: [
          const Icon(PhosphorIconsBold.treeView, size: 12),
          Text(
            '$doneSubTasks/$totalSubTasks',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskDueDateWidget extends StatelessWidget {
  const _TaskDueDateWidget(this.task, {super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    if (task.dueDate == null) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat.yMEd().format(task.dueDate!);
    const success = Colors.green;
    return Row(
      spacing: 4,
      children: [
        const Icon(Icons.calendar_today, color: success, size: 12),
        Text(
          formattedDate,
          style: textTheme.labelSmall?.copyWith(
            color: success,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DismissedContainer extends StatelessWidget {
  const _DismissedContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Icon(
        PhosphorIconsRegular.trash,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
