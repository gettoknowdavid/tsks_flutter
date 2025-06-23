import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/collections/providers/collection_form/collection_form_notifier.dart';
import 'package:tsks_flutter/ui/collections/providers/collections_notifier.dart';
import 'package:tsks_flutter/ui/collections/widgets/collection_icon_widget.dart';
import 'package:tsks_flutter/ui/collections/widgets/collection_tasks_status_widget.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_form/task_form_notifier.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_extensions.dart';

class CollectionTile extends ConsumerWidget {
  const CollectionTile({required this.collection, super.key});

  final Collection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final id = collection.id;

    final collectionForm = ref.read(collectionFormNotifierProvider.notifier);
    final taskForm = ref.read(taskFormNotifierProvider.notifier);

    Future<void> handleMenuSelection(String choice) async {
      switch (choice) {
        case 'edit':
          collectionForm.initializeWithCollection(collection);
          await context.openCollectionEditor();
        case 'delete':
          final shouldDelete = await context.showConfirmationDialog(
            title: 'Delete Collection?',
            description:
                '''You are about to delete this collection. This aaction cannot be undone. Do you want to continue?''',
          );

          if (shouldDelete ?? false) {
            await ref
                .read(collectionsNotifierProvider.notifier)
                .deleteCollection(collection);
            if (context.mounted) {
              await const CollectionsRoute().push<void>(context);
            } else {
              final location = const CollectionsRoute().location;
              await ref.read(routerConfigProvider).push<void>(location);
            }
          }
        case 'add_task':
          taskForm.collectionChanged(id);
          await context.openTaskEditor();
      }
    }

    return InkWell(
      onSecondaryTapDown: (details) => _showContextMenu(
        context,
        details,
        handleMenuSelection,
      ),
      onTap: () => CollectionRoute(id).push<void>(context),
      borderRadius: const BorderRadius.all(Radius.circular(28)),
      child: Card(
        semanticContainer: false,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadiusGeometry.all(Radius.circular(28)),
          side: BorderSide(
            width: 2,
            color: theme.colorScheme.surfaceContainer,
          ),
        ),
        child: Padding(
          padding: ResponsiveValue<EdgeInsets>(
            context,
            conditionalValues: [
              const Condition.largerThan(
                name: PHONE,
                value: EdgeInsets.all(20),
              ),
            ],
            defaultValue: const EdgeInsets.all(14),
          ).value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CollectionIconWidget(
                collection: collection,
                size: ResponsiveValue<double>(
                  context,
                  conditionalValues: [
                    const Condition.largerThan(name: PHONE, value: 44),
                  ],
                  defaultValue: 34,
                ).value,
              ),
              const Spacer(),
              Text(
                collection.title,
                style: ResponsiveValue<TextStyle>(
                  context,
                  conditionalValues: [
                    Condition.smallerThan(
                      name: MOBILE,
                      value: theme.textTheme.titleSmall,
                    ),
                    Condition.largerThan(
                      name: TABLET,
                      value: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
                    ),
                  ],
                  defaultValue: theme.textTheme.titleMedium,
                ).value,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                semanticsLabel: collection.title,
              ),
              ResponsiveValue<Widget>(
                context,
                conditionalValues: [
                  const Condition.largerThan(
                    name: PHONE,
                    value: SizedBox(height: 8),
                  ),
                ],
                defaultValue: const SizedBox.shrink(),
              ).value,
              CollectionTasksStatusWidget(collection: collection),
            ],
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
        const PopupMenuItem<String>(
          value: 'add_task',
          child: ListTile(
            leading: Icon(PhosphorIconsBold.checkSquare),
            title: Text('Add Task'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: Icon(PhosphorIconsBold.pencilSimple),
            title: Text('Edit Collection'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: const Icon(PhosphorIconsBold.trash),
            title: const Text('Delete Collection'),
            iconColor: colors.error,
            textColor: colors.error,
          ),
        ),
      ],
    );
    if (choice != null) onSelected(choice);
  }
}
