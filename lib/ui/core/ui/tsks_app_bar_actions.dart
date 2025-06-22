import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart';

class TsksAppBarActions extends ConsumerWidget {
  const TsksAppBarActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 8,
      children: [
        const AddTaskButton(),
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
