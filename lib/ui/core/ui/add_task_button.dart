import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_form/task_form_notifier.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_extensions.dart';

class AddTaskButton extends ConsumerWidget {
  const AddTaskButton({super.key, this.onPressed, this.dimension = 52});

  final VoidCallback? onPressed;
  final double dimension;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final decoration = ShapeDecoration(
      color: colors.primary,
      shape: const RoundedSuperellipseBorder(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(14)),
      ),
    );
    final fixedSizeDimension = dimension * 1.05;
    return SizedBox.square(
      dimension: dimension,
      child: IconButton(
        onPressed: () {
          if (onPressed != null) return onPressed?.call();

          final id = ref.read(routerConfigProvider).state.pathParameters['id'];
          if (id != null) {
            ref.read(taskFormNotifierProvider.notifier).collectionChanged(id);
          }

          context.openTaskEditor();
        },
        style: IconButton.styleFrom(fixedSize: Size.square(fixedSizeDimension)),
        icon: Ink(
          decoration: decoration,
          width: dimension,
          height: dimension,
          child: Icon(Icons.add, color: colors.onPrimary),
        ),
      ),
    );
  }
}
