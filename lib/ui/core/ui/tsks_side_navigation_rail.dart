import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Collection {
  const Collection(this.id, this.title, this.icon, this.color);

  final String id;
  final String title;
  final IconData icon;
  final Color color;
}

const collections = <Collection>[
  Collection('1', 'School', PhosphorIconsRegular.graduationCap, Colors.pink),
  Collection('2', 'Personal', PhosphorIconsRegular.user, Colors.cyan),
  Collection('3', 'Design', PhosphorIconsRegular.paintBrush, Colors.purple),
  Collection('4', 'Groceries', PhosphorIconsRegular.shoppingBag, Colors.amber),
];

class TsksSideNavigationRail extends StatelessWidget {
  const TsksSideNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    final useSideNavRail = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    if (!useSideNavRail) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return NavigationRail(
      minExtendedWidth: 250,
      leading: Container(
        width: 250,
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Text(
          'Collections',
          style: textTheme.titleMedium?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      extended: true,
      backgroundColor: colors.surfaceContainer,
      selectedIndex: 1,
      onDestinationSelected: (value) {},
      useIndicator: false,
      indicatorColor: Colors.transparent,
      destinations: collections.map(
        (collection) {
          return NavigationRailDestination(
            padding: const EdgeInsets.symmetric(vertical: 4),
            icon: Container(
              height: 36,
              width: 36,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: collection.color.withValues(alpha: 0.8),
                shape: const RoundedSuperellipseBorder(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
                ),
              ),
              child: Icon(collection.icon, size: 18),
            ),
            label: Text(collection.title, style: textTheme.bodyMedium),
            indicatorColor: collection.color,
          );
        },
      ).toList(),
    );
  }
}
