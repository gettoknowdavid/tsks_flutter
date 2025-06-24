import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_form/task_form_notifier.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_mover_notifier.dart';
import 'package:tsks_flutter/ui/tasks/providers/tasks_notifier.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_extensions.dart';

class TaskTile extends ConsumerWidget {
  const TaskTile({
    required this.task,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final Task task;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = task.collection;
    final tasksNotifier = ref.read(tasksNotifierProvider(collection).notifier);
    final taskFormNotifier = ref.read(taskFormNotifierProvider.notifier);
    final taskMoverNotifier = ref.read(taskMoverNotifierProvider.notifier);

    Future<void> handleMenuSelection(String choice) async {
      switch (choice) {
        case 'edit':
          taskFormNotifier.initializeWithTask(task);
          await context.openTaskEditor();
        case 'move':
          taskFormNotifier.initializeWithTask(task);
          final uid = await context.openCollectionsSelector();
          if (uid == null || uid == collection) return;
          await taskMoverNotifier.moveTaskToCollection(task, collection);
        case 'delete':
          final shouldDelete = await context.showConfirmationDialog(
            title: 'Delete Task?',
            description:
                '''You are about to delete this task. This aaction cannot be undone. Do you want to continue?''',
          );

          if (shouldDelete ?? false) {
            await tasksNotifier.deleteTask(task);
          }
        case 'add_sub_task':
          if (task.parentTask != null) return;
          taskFormNotifier.parentTaskChanged(task);
          taskFormNotifier.collectionChanged(task.collection);
          await context.openTaskEditor(parentTask: task);
      }
    }

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
        onSecondaryTapDown: (details) => _showContextMenu(
          context,
          details,
          handleMenuSelection,
        ),
        onLongPress: () async {
          final choice = await _optionsMenu(context);
          if (choice != null) await handleMenuSelection(choice);
        },
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
                    _TaskCheckboxWidget(
                      task,
                      key: const Key('TaskCheckboxWidget'),
                    ),
                    Expanded(
                      child: _TaskTitleWidget(
                        task,
                        key: const Key('TaskTitleWidget'),
                      ),
                    ),
                  ],
                ),
                _TaskDueDateWidget(task, key: const Key('TaskDueDateWidget')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showContextMenu(
    BuildContext context,
    TapDownDetails details,
    void Function(String) onSelected,
  ) async {
    final globalPosition = details.globalPosition;
    final position = RelativeRect.fromLTRB(
      globalPosition.dx,
      globalPosition.dy,
      globalPosition.dx,
      globalPosition.dy,
    );

    final choice = await _optionsMenu(context, position: position);
    if (choice != null) onSelected(choice);
  }

  Future<String?> _optionsMenu(
    BuildContext context, {
    RelativeRect? position,
  }) async {
    final colors = Theme.of(context).colorScheme;
    return showMenu<String>(
      context: context,
      position: position,
      useRootNavigator: true,
      shape: RoundedSuperellipseBorder(
        borderRadius: const BorderRadiusGeometry.all(Radius.circular(24)),
        side: BorderSide(width: 2, color: colors.secondaryContainer),
      ),
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: Icon(PhosphorIconsBold.pencilSimple),
            title: Text('Edit Task'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'move',
          child: ListTile(
            leading: Icon(PhosphorIconsBold.folderMinus),
            title: Text('Move Task'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: const Icon(PhosphorIconsBold.trash),
            title: const Text('Delete Task'),
            iconColor: colors.error,
            textColor: colors.error,
          ),
        ),
      ],
    );
  }
}

class _TaskCheckboxWidget extends ConsumerWidget {
  const _TaskCheckboxWidget(this.task, {super.key});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Skeleton.shade(
      child: Transform.scale(
        scale: 1.4,
        child: SizedBox.square(
          dimension: 24,
          child: Checkbox(
            value: task.isDone,
            onChanged: (value) {
              final cId = task.collection;
              final notifier = ref.read(tasksNotifierProvider(cId).notifier);
              notifier.isTaskChanged(task);
            },
          ),
        ),
      ),
    );
  }
}

class _TaskTitleWidget extends StatelessWidget {
  const _TaskTitleWidget(this.task, {super.key});

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

class _TaskDueDateWidget extends StatelessWidget {
  const _TaskDueDateWidget(this.task, {super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    if (task.dueDate == null) return const SizedBox.shrink();

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
