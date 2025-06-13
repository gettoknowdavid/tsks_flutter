import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/ui/todos/providers/collection_form/collection_form.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_form_widget.dart';

class AddNewCollectionButton extends ConsumerWidget {
  const AddNewCollectionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final status = ref.watch(collectionFormProvider.select((s) => s.status));
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);

    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        if (isMobile) {
          showModalBottomSheet<void>(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            isDismissible: !status.isLoading,
            builder: (context) => Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: const CollectionFormWidget(),
            ),
          );
        } else {
          showDialog<void>(
            context: context,
            barrierDismissible: !status.isLoading,
            builder: (context) => const Dialog(
              alignment: Alignment.topCenter,
              insetPadding: EdgeInsets.fromLTRB(40, 160, 40, 0),
              child: CollectionFormWidget(),
            ),
          );
        }
      },
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
