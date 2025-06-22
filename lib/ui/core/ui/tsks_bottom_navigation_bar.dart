import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/ui/core/models/destination.dart';
import 'package:tsks_flutter/ui/core/ui/add_task_button.dart';

class TsksBottomNavigationBar extends StatelessWidget {
  const TsksBottomNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final useSideNavRail = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    if (useSideNavRail) return const SizedBox.shrink();
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinationsWidgets,
    );
  }

  List<Widget> get destinationsWidgets {
    final tiles = <Widget>[];
    final destinationsLength = destinations.length;

    for (var i = 0; i < destinationsLength; i++) {
      if (i == 2) {
        tiles.add(const Center(child: AddTaskButton()));
      }

      tiles.add(
        NavigationDestination(
          icon: Icon(destinations[i].icon),
          label: destinations[i].label,
        ),
      );
    }

    return tiles;
  }
}
