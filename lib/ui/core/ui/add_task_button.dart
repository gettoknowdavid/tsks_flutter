import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_form/task_form_notifier.dart';
import 'package:tsks_flutter/ui/tasks/widgets/task_extensions.dart';

class AddTaskButton extends ConsumerWidget {
  const AddTaskButton({super.key, this.onPressed, this.dimension = 56});

  final VoidCallback? onPressed;
  final double dimension;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final decoration = ShapeDecoration(
      color: colors.primary,
      shape: const RoundedSuperellipseBorder(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(16)),
      ),
    );
    return IconButton(
      onPressed: () {
        if (onPressed != null) return onPressed?.call();

        final id = ref.read(routerConfigProvider).state.pathParameters['id'];
        if (id != null) {
          ref.read(taskFormNotifierProvider.notifier).collectionChanged(id);
        }

        context.openTaskEditor();
      },
      style: IconButton.styleFrom(
        fixedSize: const Size.square(70),
        iconSize: 16,
      ),
      icon: Ink(
        decoration: decoration,
        width: dimension,
        height: dimension,
        child: Icon(Icons.add, color: colors.onPrimary),
      ),
    );
  }
}
