import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_form_widget.dart';
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

  Future<void> openTodoEditor() async {
    final isMobile = ResponsiveBreakpoints.of(this).smallerThan(TABLET);
    if (isMobile) {
      await showModalBottomSheet<void>(
        context: this,
        useRootNavigator: true,
        isScrollControlled: true,
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
        builder: (context) => const MaxWidthBox(
          maxWidth: 560,
          child: Dialog(
            alignment: Alignment.topCenter,
            insetPadding: EdgeInsets.fromLTRB(40, 160, 40, 0),
            child: TodoFormWidget(),
          ),
        ),
      );
    }
  }

  Future<bool?> deleteTodoConfirmationDialog() async {
    return showDialog<bool>(
      context: this,
      builder: (context) => MaxWidthBox(
        maxWidth: 560,
        child: AlertDialog(
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
      ),
    );
  }
}
