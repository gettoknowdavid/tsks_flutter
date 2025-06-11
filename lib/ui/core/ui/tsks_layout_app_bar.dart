import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/core/models/destination.dart';
import 'package:tsks_flutter/ui/core/ui/user_avatar.dart';

class TsksLayoutAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const TsksLayoutAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final useSideNavRail = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    if (!useSideNavRail) return const SizedBox.shrink();

    return AppBar(
      backgroundColor: colors.surfaceContainerHigh,
      scrolledUnderElevation: 0,
      toolbarHeight: 64,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(PhosphorIconsRegular.list),
      ),
      title: const _NavigationList(key: Key('TsksAppBarNavigationList')),
      actions: const [_AppBarActions(key: Key('TsksAppBarActions'))],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class _NavigationList extends ConsumerWidget {
  const _NavigationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final router = ref.read(routerConfigProvider);

    return Row(
      spacing: 12,
      children: appBarDestinations.map((destination) {
        bool isActive;
        final currentPath = router.currentLocation;
        final collectionsPath = const CollectionsRoute().location;
        if (destination.path == collectionsPath) {
          // If the destination is 'Collections', it should be active if
          // the current path starts with '/collections' (e.g., /collections/id)
          isActive = currentPath.startsWith(collectionsPath);
        } else {
          // For other destinations, exact match
          isActive = currentPath == destination.path;
        }

        final color = isActive ? colors.onSurface : colors.outline;

        return TextButton.icon(
          onPressed: () => router.push<void>(destination.path),
          style: TextButton.styleFrom(foregroundColor: color),
          icon: Icon(destination.icon, size: 20),
          label: Text(destination.label),
        );
      }).toList(),
    );
  }
}

class _AppBarActions extends ConsumerWidget {
  const _AppBarActions({super.key});

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
          onPressed: () {},
          iconSize: 18,
          icon: const Icon(PhosphorIconsBold.magnifyingGlass),
        ),
        IconButton(
          onPressed: () {},
          iconSize: 18,
          icon: const Icon(PhosphorIconsBold.bell),
        ),
        const UserAvatar(),
        const SizedBox(width: 16),
      ],
    );
  }
}
