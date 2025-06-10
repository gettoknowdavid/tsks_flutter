import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/ui/core/models/destination.dart';

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
      destinations: destinations.map(
        (destination) {
          return NavigationDestination(
            icon: Icon(destination.icon),
            label: destination.label,
          );
        },
      ).toList(),
    );
  }
}
