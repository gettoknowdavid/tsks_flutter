import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/core/models/destination.dart';

class TsksAppBarNavigationList extends ConsumerWidget {
  const TsksAppBarNavigationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 12,
      children: appBarDestinations
          .map((destination) => _AppBarNavigationItem(destination: destination))
          .toList(),
    );
  }
}

class _AppBarNavigationItem extends HookConsumerWidget {
  const _AppBarNavigationItem({required this.destination});
  final Destination destination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(
      routerLocationProvider.select((selector) {
        final path = selector.valueOrNull;
        if (destination.path == '/collections') {
          return path?.startsWith('/collections') ?? false;
        } else {
          return path == destination.path;
        }
      }),
    );

    final colors = Theme.of(context).colorScheme;
    final color = isActive ? colors.onSurface : colors.outline;

    return TextButton.icon(
      onPressed: () => ref.read(routerConfigProvider).go(destination.path),
      style: TextButton.styleFrom(foregroundColor: color),
      icon: Icon(destination.icon, size: 20),
      label: Text(destination.label),
    );
  }
}
