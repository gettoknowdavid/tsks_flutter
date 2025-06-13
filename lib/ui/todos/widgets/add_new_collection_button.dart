import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/ui/todos/providers/collection_form/collection_form.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_editor_dialog.dart';

class AddNewCollectionButton extends ConsumerWidget {
  const AddNewCollectionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final status = ref.watch(collectionFormProvider.select((s) => s.status));

    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        showDialog<void>(
          context: context,
          barrierDismissible: !status.isLoading,
          builder: (context) => const CollectionEditorDialog(),
        );
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
