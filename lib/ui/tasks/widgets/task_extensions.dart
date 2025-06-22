import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/models/tasks/task.dart';
import 'package:tsks_flutter/ui/collections/widgets/collection_form_widget.dart';
import 'package:tsks_flutter/ui/collections/widgets/collection_list_widget.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_form_widget.dart';

extension TaskExtensions on BuildContext {
  Future<void> openCollectionEditor() async {
    final isMobile = ResponsiveBreakpoints.of(this).smallerThan(TABLET);
    if (isMobile) {
      await showModalBottomSheet<void>(
        context: this,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) => Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const CollectionFormWidget(),
        ),
      );
    } else {
      await showDialog<void>(
        context: this,
        barrierDismissible: false,
        builder: (context) => const MaxWidthBox(
          maxWidth: 560,
          child: Dialog(
            alignment: Alignment.topCenter,
            insetPadding: EdgeInsets.fromLTRB(40, 160, 40, 0),
            child: CollectionFormWidget(),
          ),
        ),
      );
    }
  }

  Future<void> openTaskEditor({Task? parentTask}) async {
    final theme = Theme.of(this);
    final isMobile = ResponsiveBreakpoints.of(this).smallerThan(TABLET);
    if (isMobile) {
      await showModalBottomSheet<void>(
        context: this,
        useRootNavigator: true,
        isDismissible: false,
        builder: (context) => Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const TaskFormWidget(),
        ),
      );
    } else {
      await showDialog<void>(
        context: this,
        barrierDismissible: false,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: MaxWidthBox(
              maxWidth: 560,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 160, 40, 0),
                child: Column(
                  children: [
                    if (parentTask != null) ...[
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Parent Task',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(parentTask.title),
                          ],
                        ),
                        subtitle: DefaultTextStyle(
                          style: theme.textTheme.labelSmall!.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 8),
                              Text('COLLECTION: Groceries'),
                              Text('DUE DATE: Tuesday 12th June 2025'),
                            ],
                          ),
                        ),
                        tileColor: theme.colorScheme.surfaceContainerHigh,
                        shape: RoundedSuperellipseBorder(
                          side: BorderSide(
                            width: 2,
                            color: theme.colorScheme.tertiaryContainer,
                          ),
                          borderRadius: const BorderRadiusGeometry.all(
                            Radius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const Dialog(
                      alignment: Alignment.topCenter,
                      insetPadding: EdgeInsets.zero,
                      child: TaskFormWidget(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Future<bool?> showConfirmationDialog({
    required String title,
    required String description,
    Widget? action,
    Widget? cancelButton,
  }) async {
    return showDialog<bool>(
      context: this,
      builder: (context) => MaxWidthBox(
        maxWidth: 560,
        child: AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            if (action == null)
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              )
            else
              action,
            if (cancelButton == null)
              ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              )
            else
              cancelButton,
          ],
        ),
      ),
    );
  }

  Future<String?> openCollectionsSelector() {
    final isMobile = ResponsiveBreakpoints.of(this).smallerThan(TABLET);

    if (isMobile) {
      return showModalBottomSheet<String>(
        context: this,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) => Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: CollectionListWidget(
            onCollectionSelected: (id) => Navigator.pop(context, id),
          ),
        ),
      );
    } else {
      return showDialog<String>(
        context: this,
        barrierDismissible: false,
        builder: (context) => MaxWidthBox(
          maxWidth: 560,
          child: Dialog(
            alignment: Alignment.topCenter,
            insetPadding: const EdgeInsets.fromLTRB(40, 160, 40, 0),
            child: CollectionListWidget(
              onCollectionSelected: (uid) => Navigator.pop(context, uid),
            ),
          ),
        ),
      );
    }
  }
}
