import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_app_bar_actions.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_app_bar_navigation_list.dart';

class TsksLayoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TsksLayoutAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
      title: const TsksAppBarNavigationList(),
      actions: const [TsksAppBarActions()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
