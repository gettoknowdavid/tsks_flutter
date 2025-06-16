import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';
import 'package:tsks_flutter/ui/todos/providers/todo_form/todo_form_notifier.dart';
import 'package:tsks_flutter/ui/todos/providers/todos_provider.dart';
import 'package:tsks_flutter/ui/todos/widgets/todo_extensions.dart';

class TodoTile extends ConsumerWidget {
  const TodoTile({
    required this.todo,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final Todo todo;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey<Uid>(todo.uid),
      background: const _DismissedContainer(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => switch (direction) {
        DismissDirection.endToStart => {},
        _ => null,
      },
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        onTap: () {
          ref.read(todoFormProvider.notifier).initializeWithTodo(todo);
          context.openTodoEditor();
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
                    _TodoCheckboxWidget(todo: todo),
                    Expanded(child: _TodoTitleWidget(todo: todo)),
                    _TodoOptions(todo: todo),
                  ],
                ),
                _TodoSubtileWidget(todo: todo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TodoCheckboxWidget extends ConsumerWidget {
  const _TodoCheckboxWidget({required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(todosProvider.notifier);
    return Skeleton.shade(
      child: Transform.scale(
        scale: 1.4,
        child: SizedBox.square(
          dimension: 24,
          child: Checkbox(
            value: todo.isDone,
            onChanged: (value) {
              if (value == null) return;
              final udpatedTodo = todo.copyWith(isDone: value);
              notifier.isTodoChanged(udpatedTodo);
            },
          ),
        ),
      ),
    );
  }
}

class _TodoTitleWidget extends StatelessWidget {
  const _TodoTitleWidget({required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      todo.title.getOrCrash,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: theme.colorScheme.onSurfaceVariant,
        decoration: todo.isDone ? TextDecoration.lineThrough : null,
      ),
    );
  }
}

class _TodoSubtileWidget extends StatelessWidget {
  const _TodoSubtileWidget({required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    if (todo.dueDate == null) return const SizedBox();

    final textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat.yMEd().format(todo.dueDate!);
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

class _TodoOptions extends ConsumerWidget {
  const _TodoOptions({required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      child: const Icon(PhosphorIconsBold.dotsThree),
      onSelected: (String value) async {
        if (value == 'Edit') {
          ref.read(todoFormProvider.notifier).initializeWithTodo(todo);
          await context.openTodoEditor();
        }

        if (value == 'Delete' && context.mounted) {
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Todo?'),
              content: const Text(
                '''You are about to delete this todo. This aaction cannot be undone. Do you want to continue?''',
              ),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          );

          if (shouldDelete ?? false) {
            await ref.read(todosProvider.notifier).deleteTodo(todo);
          }
        }
      },
      itemBuilder: (BuildContext context) {
        return ['Add sub-todo', 'Edit', 'Delete'].map((String choice) {
          return PopupMenuItem<String>(value: choice, child: Text(choice));
        }).toList();
      },
    );
  }
}
