import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_form/task_form_notifier.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_mover_notifier.dart';
import 'package:tsks_flutter/ui/tasks/providers/tasks_notifier.dart';
import 'package:tsks_flutter/ui/tasks/widgets/base_task_tile_widget.dart';
import 'package:tsks_flutter/ui/tasks/widgets/sub_task_list_widget.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_extensions.dart';

class TaskTile extends HookConsumerWidget {
  const TaskTile({
    required this.task,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final Task task;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = useState<bool>(false);

    final collection = task.collection;
    final tasksNotifier = ref.read(tasksNotifierProvider(collection).notifier);
    final taskFormNotifier = ref.read(taskFormNotifierProvider.notifier);
    final taskMoverNotifier = ref.read(taskMoverNotifierProvider.notifier);

    final isSubTask = task.parentTask != null;

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

    return Column(
      children: [
        BaseTaskTileWidget(
          task: task,
          onLongPress: () async {
            final choice = await _optionsMenu(context, isSubTask: isSubTask);
            if (choice != null) await handleMenuSelection(choice);
          },
          onSecondaryTapDown: (details) => _showContextMenu(
            context,
            details,
            handleMenuSelection,
            isSubTask: isSubTask,
          ),
          trailing: isSubTask
              ? null
              : IconButton(
                  onPressed: () => isExpanded.value = !isExpanded.value,
                  iconSize: 16,
                  icon: isExpanded.value
                      ? const Icon(PhosphorIconsBold.caretUp)
                      : const Icon(PhosphorIconsBold.caretDown),
                ),
        ),
        if (!isSubTask)
          if (isExpanded.value) ...[
            const SizedBox(height: 6),
            SubTaskListWidget(
              collection: task.collection,
              parentTask: task.id,
            ),
          ],
      ],
    );
  }

  Future<void> _showContextMenu(
    BuildContext context,
    TapDownDetails details,
    void Function(String) onSelected, {
    bool isSubTask = false,
  }) async {
    final globalPosition = details.globalPosition;
    final position = RelativeRect.fromLTRB(
      globalPosition.dx,
      globalPosition.dy,
      globalPosition.dx,
      globalPosition.dy,
    );

    final choice = await _optionsMenu(
      context,
      isSubTask: isSubTask,
      position: position,
    );
    if (choice != null) onSelected(choice);
  }

  Future<String?> _optionsMenu(
    BuildContext context, {
    RelativeRect? position,
    bool isSubTask = false,
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
        PopupMenuItem<String>(
          value: 'add_sub_task',
          enabled: !isSubTask,
          child: const ListTile(
            leading: Icon(PhosphorIconsBold.checkSquare),
            title: Text('Add Sub-Task'),
          ),
        ),
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
