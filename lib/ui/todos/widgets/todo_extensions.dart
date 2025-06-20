import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/todo.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_form_widget.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_list_widget.dart';
import 'package:tsks_flutter/ui/todos/widgets/todo_form_widget.dart';

extension TodoExtensions on BuildContext {
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

  Future<void> openTodoEditor({Todo? parentTodo}) async {
    final theme = Theme.of(this);
    final isMobile = ResponsiveBreakpoints.of(this).smallerThan(TABLET);
    if (isMobile) {
      await showModalBottomSheet<void>(
        context: this,
        useRootNavigator: true,
        isDismissible: false,
        builder: (context) => Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const TodoFormWidget(),
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
                    if (parentTodo != null) ...[
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Parent Todo',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(parentTodo.title.getOrCrash),
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
                      child: TodoFormWidget(),
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

  Future<Uid?> openCollectionsSelector() {
    final isMobile = ResponsiveBreakpoints.of(this).smallerThan(TABLET);

    if (isMobile) {
      return showModalBottomSheet<Uid>(
        context: this,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) => Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: CollectionListWidget(
            onCollectionSelected: (uid) => Navigator.pop(context, uid),
          ),
        ),
      );
    } else {
      return showDialog<Uid>(
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
