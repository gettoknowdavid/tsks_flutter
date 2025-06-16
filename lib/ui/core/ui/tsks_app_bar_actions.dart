import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/core/ui/user_avatar.dart';
import 'package:tsks_flutter/ui/todos/providers/todo_form/todo_form_notifier.dart';
import 'package:tsks_flutter/ui/todos/widgets/todo_extensions.dart';

class TsksAppBarActions extends ConsumerWidget {
  const TsksAppBarActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      spacing: 8,
      children: [
        SizedBox.square(
          dimension: 32,
          child: IconButton.filled(
            onPressed: () {
              final collectionUidFromPath = ref
                  .read(routerConfigProvider)
                  .state
                  .pathParameters['uid'];

              if (collectionUidFromPath != null) {
                final uid = Uid(collectionUidFromPath);
                ref.read(todoFormProvider.notifier).collectionChanged(uid);
              }

              context.openTodoEditor();
            },
            icon: const Icon(PhosphorIconsBold.plus),
            style: IconButton.styleFrom(
              iconSize: 16,
              foregroundColor: colors.onPrimary,
              shape: const RoundedSuperellipseBorder(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () => const SearchRoute().go(context),
          iconSize: 18,
          icon: const Icon(PhosphorIconsBold.magnifyingGlass),
        ),
        IconButton(
          onPressed: () => const NotificationsRoute().go(context),
          iconSize: 18,
          icon: const Icon(PhosphorIconsBold.bell),
        ),
        const UserAvatar(),
        const SizedBox(width: 16),
      ],
    );
  }
}
