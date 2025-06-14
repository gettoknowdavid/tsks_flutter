import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_form_widget.dart';

class AddNewCollectionButton extends ConsumerWidget {
  const AddNewCollectionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => context.openCollectionEditor(),
      iconSize: 32,
      style: IconButton.styleFrom(
        side: BorderSide(width: 2, color: colors.surfaceContainer),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      ),
    );
  }
}

extension CollectionEditorX on BuildContext {
  Future<void> openCollectionEditor() async {
    final isMobile = ResponsiveBreakpoints.of(this).equals(MOBILE);
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
}
