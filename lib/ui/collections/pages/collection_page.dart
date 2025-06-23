import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/collections/providers/collection_form/collection_form_notifier.dart';
import 'package:tsks_flutter/ui/collections/providers/collection_notifier.dart';
import 'package:tsks_flutter/ui/core/ui/page_widget.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_snackbar.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_form/task_form_notifier.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_mover_notifier.dart';
import 'package:tsks_flutter/ui/tasks/providers/tasks_notifier.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_extensions.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_list_widget.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(taskMoverNotifierProvider, (previous, next) {
      if (previous == next) return;
      switch (next) {
        case AsyncError(:final error):
          context.showErrorSnackBar(error.toString());
        case AsyncData(:final value):
          if (value == null) return;
          final notifier = ref.read(tasksNotifierProvider(id).notifier);
          notifier.optimisticallyDelete(value);
          context.showSuccessSnackBar('Todo moved successfully.');
      }
    });

    ref.listen(tasksNotifierProvider(id), (previous, next) {
      if (previous == next) return;
      next.whenOrNull(
        error: (error, stackTrace) {
          final message = errorMessage(error);
          context.showErrorSnackBar(message);
        },
      );
    });

    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    final isTodoMoveInProgress = ref.watch(
      taskMoverNotifierProvider.select((selector) => selector.isLoading),
    );

    return Scaffold(
      appBar: isMobile ? const _AppBar(key: Key('CollectionPageAppBar')) : null,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: MaxWidthBox(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          maxWidth: ResponsiveValue<double>(
            context,
            conditionalValues: [
              const Condition.largerThan(name: MOBILE, value: 720),
              const Condition.largerThan(name: DESKTOP, value: 1000),
            ],
            defaultValue: double.infinity,
          ).value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              if (!isMobile) ...[
                const Row(
                  children: [
                    PageBackButton(),
                    SizedBox(width: 16),
                    Expanded(child: _Title(key: Key('CollectionPageTitle'))),
                    _MoreOptions(key: Key('CollectionPopupOptionsMenu')),
                  ],
                ),
              ],
              const SizedBox(height: 40),
              const _AddTodoButton(key: Key('CollectionPageAddTodoButton')),
              const SizedBox(height: 40),

              if (isTodoMoveInProgress)
                const Skeletonizer(child: TaskListWidget())
              else
                const TaskListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddTodoButton extends ConsumerWidget {
  const _AddTodoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    final routerConfig = ref.watch(routerConfigProvider);
    final collectionId = routerConfig.state.pathParameters['id'];

    return ListTile(
      leading: const Icon(PhosphorIconsFill.plusCircle),
      title: const Text('Add a task'),
      shape: RoundedSuperellipseBorder(
        borderRadius: const BorderRadiusGeometry.all(Radius.circular(16)),
        side: BorderSide(width: 2, color: colors.outlineVariant),
      ),
      onTap: () {
        final taskFormNotifier = ref.read(taskFormNotifierProvider.notifier);
        taskFormNotifier.collectionChanged(collectionId);
        context.openTaskEditor();
      },
    );
  }
}

class _Title extends ConsumerWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routerConfigProvider);
    final collectionId = routerConfig.state.pathParameters['id'];
    final collection = ref.watch(collectionNotifierProvider(collectionId));

    return switch (collection) {
      AsyncError() => const PageTitle('An error occurred'),
      AsyncData(:final value) => PageTitle(value.title),
      _ => const Skeletonizer(child: PageTitle('Fake Title')),
    };
  }
}

class _AppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: const PageBackButton(),
      title: const _Title(key: Key('CollectionPageTitle')),
      titleSpacing: 0,
      centerTitle: false,
      actions: const [_MoreOptions()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MoreOptions extends ConsumerWidget {
  const _MoreOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routerConfigProvider);
    final id = routerConfig.state.pathParameters['id'];
    final collection = ref.watch(collectionNotifierProvider(id)).valueOrNull;
    return PopupMenuButton<String>(
      child: const Icon(PhosphorIconsBold.dotsThree),
      onSelected: (String value) async {
        if (collection == null) return;
        if (value == 'edit') {
          final notifier = ref.read(collectionFormNotifierProvider.notifier);
          notifier.initializeWithCollection(collection);
          await context.openCollectionEditor();
        } else if (value == 'delete') {
          final shouldDelete = await context.showConfirmationDialog(
            title: 'Delete Collection?',
            description:
                '''You are about to delete this task. This aaction cannot be undone. Do you want to continue?''',
          );
          if (shouldDelete ?? false) {
            final notifier = ref.read(collectionNotifierProvider(id).notifier);
            await notifier.deleteCollection();
            if (context.mounted) {
              await const CollectionsRoute().push<void>(context);
            } else {
              final location = const CollectionsRoute().location;
              await ref.read(routerConfigProvider).push<void>(location);
            }
          }
        }
      },
      itemBuilder: (BuildContext context) {
        return ['edit', 'delete'].map((String choice) {
          return PopupMenuItem<String>(value: choice, child: Text(choice));
        }).toList();
      },
    );
  }
}
