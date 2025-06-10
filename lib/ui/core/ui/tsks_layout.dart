import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_bottom_navigation_bar.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_layout_app_bar.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_side_navigation_rail.dart';

class TsksLayout extends ConsumerWidget {
  const TsksLayout({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('TsksLayout'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const TsksLayoutAppBar(),
      body: Row(
        children: [
          const TsksSideNavigationRail(key: Key('TsksSideNavRail')),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: TsksBottomNavigationBar(
        key: const Key('TsksBottomNavigationBar'),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: onTap,
      ),
    );
  }

  void onTap(int index) {
    return navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
