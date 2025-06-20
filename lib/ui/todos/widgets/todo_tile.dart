import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';
import 'package:tsks_flutter/ui/todos/providers/todo_form/todo_form_notifier.dart';
import 'package:tsks_flutter/ui/todos/providers/todo_mover.dart';
import 'package:tsks_flutter/ui/todos/providers/todos_provider.dart';
import 'package:tsks_flutter/ui/todos/widgets/base_todo_tile_widget.dart';
import 'package:tsks_flutter/ui/todos/widgets/sub_todo_list_widget.dart';
import 'package:tsks_flutter/ui/todos/widgets/todo_extensions.dart';

class TodoTile extends HookConsumerWidget {
  const TodoTile({
    required this.todo,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final Todo todo;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = useState<bool>(false);

    final collectionUid = todo.collectionUid;
    final todoFormNotifier = ref.read(todoFormProvider.notifier);

    final isSubTodo = todo.parentTodoUid != null;

    Future<void> handleMenuSelection(String choice) async {
      switch (choice) {
        case 'edit':
          todoFormNotifier.initializeWithTodo(todo);
          await context.openTodoEditor();
        case 'move':
          todoFormNotifier.initializeWithTodo(todo);
          final uid = await context.openCollectionsSelector();
          if (uid == null || uid == collectionUid) return;
          await ref
              .read(todoMoverProvider.notifier)
              .moveTodoToCollection(todo, collectionUid);
        case 'delete':
          final shouldDelete = await context.showConfirmationDialog(
            title: 'Delete Todo?',
            description:
                '''You are about to delete this todo. This aaction cannot be undone. Do you want to continue?''',
          );

          if (shouldDelete ?? false) {
            final notifier = ref.read(todosProvider(collectionUid).notifier);
            await notifier.deleteTodo(todo);
          }
        case 'add_sub_todo':
          if (todo.parentTodoUid != null) return;
          todoFormNotifier.parentTodoChanged(todo);
          todoFormNotifier.collectionChanged(todo.collectionUid);
          await context.openTodoEditor(parentTodo: todo);
      }
    }

    return Column(
      children: [
        BaseTodoListTile(
          todo: todo,
          onSecondaryTapDown: (details) => _showContextMenu(
            context,
            details,
            handleMenuSelection,
            isSubTodo: isSubTodo,
          ),
          trailing: isSubTodo
              ? null
              : IconButton(
                  onPressed: () => isExpanded.value = !isExpanded.value,
                  iconSize: 16,
                  icon: isExpanded.value
                      ? const Icon(PhosphorIconsBold.caretUp)
                      : const Icon(PhosphorIconsBold.caretDown),
                ),
        ),
        if (!isSubTodo)
          if (isExpanded.value) ...[
            const SizedBox(height: 6),
            SubTodoListWidget(
              collectionUid: todo.collectionUid,
              parentTodoUid: todo.uid,
            ),
          ],
      ],
    );
  }

  Future<void> _showContextMenu(
    BuildContext context,
    TapDownDetails details,
    void Function(String) onSelected, {
    bool isSubTodo = false,
  }) async {
    final colors = Theme.of(context).colorScheme;

    final globalPosition = details.globalPosition;
    final position = RelativeRect.fromLTRB(
      globalPosition.dx,
      globalPosition.dy,
      globalPosition.dx,
      globalPosition.dy,
    );

    final choice = await showMenu<String>(
      context: context,
      position: position,
      useRootNavigator: true,
      shape: RoundedSuperellipseBorder(
        borderRadius: const BorderRadiusGeometry.all(Radius.circular(24)),
        side: BorderSide(width: 2, color: colors.secondaryContainer),
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'add_sub_todo',
          enabled: !isSubTodo,
          child: const ListTile(
            leading: Icon(PhosphorIconsBold.checkSquare),
            title: Text('Add Sub-Todo'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: Icon(PhosphorIconsBold.pencilSimple),
            title: Text('Edit Todo'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'move',
          child: ListTile(
            leading: Icon(PhosphorIconsBold.folderMinus),
            title: Text('Move Todo'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: const Icon(PhosphorIconsBold.trash),
            title: const Text('Delete Todo'),
            iconColor: colors.error,
            textColor: colors.error,
          ),
        ),
      ],
    );
    if (choice != null) onSelected(choice);
  }
}
