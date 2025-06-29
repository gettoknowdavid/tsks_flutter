import 'package:flutter/material.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_extensions.dart';

class AddNewCollectionButton extends StatelessWidget {
  const AddNewCollectionButton({super.key});

  @override
  Widget build(BuildContext context) {
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
