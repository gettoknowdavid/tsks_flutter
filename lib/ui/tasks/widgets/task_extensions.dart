import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
        builder: (context) => Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const CollectionFormWidget(),
        ),
      );
    } else {
      await showDialog<void>(
        context: this,
        builder: (context) => const MaxWidthBox(
          maxWidth: 640,
          child: Dialog(
            alignment: Alignment.topCenter,
            insetPadding: EdgeInsets.fromLTRB(40, 160, 40, 0),
            child: CollectionFormWidget(),
          ),
        ),
      );
    }
  }

  Future<void> openTaskEditor() async {
    final isMobile = ResponsiveBreakpoints.of(this).smallerThan(TABLET);
    if (isMobile) {
      await showModalBottomSheet<void>(
        context: this,
        useRootNavigator: true,
        builder: (context) => Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const TaskFormWidget(),
        ),
      );
    } else {
      await showDialog<void>(
        context: this,
        builder: (context) => const MaxWidthBox(
          maxWidth: 640,
          child: Dialog(
            alignment: Alignment.topCenter,
            insetPadding: EdgeInsets.fromLTRB(40, 160, 40, 0),
            child: TaskFormWidget(),
          ),
        ),
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
        maxWidth: 640,
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
          maxWidth: 640,
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
