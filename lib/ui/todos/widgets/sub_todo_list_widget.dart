import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/constants/fake_models.dart';
import 'package:tsks_flutter/domain/core/exceptions/exceptions.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';
import 'package:tsks_flutter/ui/todos/providers/sub_todos_provider.dart';
import 'package:tsks_flutter/ui/todos/widgets/todo_tile.dart';

class SubTodoListWidget extends ConsumerWidget {
  const SubTodoListWidget({
    required this.collectionUid,
    required this.parentTodoUid,
    super.key,
  });

  final Uid collectionUid;
  final Uid parentTodoUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subTodos = ref.watch(
      subTodosProvider(
        collectionUid: collectionUid,
        parentTodoUid: parentTodoUid,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: switch (subTodos) {
        AsyncLoading() => TodoListBuilder(fakeTodos, isLoading: true),
        AsyncData(:final value) => TodoListBuilder(value),
        AsyncError(:final error) => Text((error as TsksException).message),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class TodoListBuilder extends StatelessWidget {
  const TodoListBuilder(this.todos, {this.isLoading = false, super.key});

  final List<Todo?> todos;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) return const SizedBox.shrink();
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todos.length,
        separatorBuilder: (context, _) => const SizedBox(height: 6),
        itemBuilder: (context, index) => TodoTile(
          key: ValueKey<Uid>(todos[index]!.uid),
          todo: todos[index]!,
        ),
      ),
    );
  }
}
