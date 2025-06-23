import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
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
                    _TaskCheckboxWidget(task: task),
                    Expanded(child: _TaskTitleWidget(task: task)),
                    trailing ?? const SizedBox.shrink(),
                  ],
                ),
                _TaskSubtileWidget(task: task),
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
    final notifier = ref.read(tasksNotifierProvider(task.collection).notifier);
    return Skeleton.shade(
      child: Transform.scale(
        scale: 1.4,
        child: SizedBox.square(
          dimension: 24,
          child: Checkbox(
            value: task.isDone,
            onChanged: (value) => notifier.isTaskChanged(task),
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

class _TaskSubtileWidget extends StatelessWidget {
  const _TaskSubtileWidget({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    if (task.dueDate == null) return const SizedBox();

    final textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat.yMEd().format(task.dueDate!);
    const success = Colors.green;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 8, 0),
      child: Row(
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
      ),
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
