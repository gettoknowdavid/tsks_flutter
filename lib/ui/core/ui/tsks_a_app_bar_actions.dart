import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/core/ui/user_avatar.dart';

class TsksAAppBarActions extends ConsumerWidget {
  const TsksAAppBarActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final router = ref.read(routerConfigProvider);

    return Row(
      spacing: 8,
      children: [
        SizedBox.square(
          dimension: 32,
          child: IconButton.filled(
            onPressed: () {},
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
          onPressed: () => router.go(const SearchRoute().location),
          iconSize: 18,
          icon: const Icon(PhosphorIconsBold.magnifyingGlass),
        ),
        IconButton(
          onPressed: () => router.go(const NotificationsRoute().location),
          iconSize: 18,
          icon: const Icon(PhosphorIconsBold.bell),
        ),
        const UserAvatar(),
        const SizedBox(width: 16),
      ],
    );
  }
}
