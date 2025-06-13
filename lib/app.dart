import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/auth/providers/auth_repository_provider.dart';
import 'package:tsks_flutter/ui/auth/providers/session/session.dart';
import 'package:tsks_flutter/ui/core/themes/themes.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart' show TsksCustomScrollBehavior;

class TsksApp extends ConsumerWidget {
  const TsksApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userChangesProvider);
    ref.watch(sessionProvider);
    ref.watch(tsksRouterProvider);
    ref.watch(routerConfigProvider);
    return const TsksAppView();
  }
}

class TsksAppView extends ConsumerWidget {
  const TsksAppView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routerConfigProvider);
    return MaterialApp.router(
      routeInformationParser: routerConfig.routeInformationParser,
      routerDelegate: routerConfig.routerDelegate,
      routeInformationProvider: routerConfig.routeInformationProvider,
      theme: TsksTheme.lightTheme,
      darkTheme: TsksTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const TsksCustomScrollBehavior(),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: PHONE),
          const Breakpoint(start: 451, end: 600, name: MOBILE),
          const Breakpoint(start: 600, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
