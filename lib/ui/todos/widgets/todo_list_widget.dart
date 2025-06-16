import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/constants/fake_models.dart';
import 'package:tsks_flutter/domain/core/exceptions/exceptions.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/todos/providers/todos_provider.dart';
import 'package:tsks_flutter/ui/todos/widgets/todo_tile.dart';

class TodoListWidget extends ConsumerWidget {
  const TodoListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerConfigProvider);
    final uidString = router.state.pathParameters['uid'];
    final collectionUid = uidString != null ? Uid(uidString) : null;
    final todos = ref.watch(todosProvider(collectionUid));
    return switch (todos) {
      AsyncLoading() => _TodoList(fakeTodos, isLoading: true),
      AsyncData(:final value) => _TodoList(value),
      AsyncError(:final error) => Text((error as TsksException).message),
      _ => const SizedBox.shrink(),
    };
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList(this.todos, {this.isLoading = false});

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
        separatorBuilder: (context, _) => const SizedBox(height: 4),
        itemBuilder: (context, index) => TodoTile(
          key: ValueKey<Uid>(todos[index]!.uid),
          todo: todos[index]!,
        ),
      ),
    );
  }
}
