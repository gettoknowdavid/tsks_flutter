import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/core/themes/themes.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart' show TsksCustomScrollBehavior;
import 'package:tsks_flutter/ui/providers/providers.dart';

class TsksApp extends ConsumerWidget {
  const TsksApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userChangesProvider);
    ref.watch(sessionProvider);
    final routerConfig = ref.watch(tsksRouterProvider.notifier).routerConfig;
    return TsksAppView(routerConfig: routerConfig);
  }
}

class TsksAppView extends StatelessWidget {
  const TsksAppView({required this.routerConfig, super.key});
  final GoRouter routerConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routerConfig,
      theme: TsksTheme.lightTheme,
      darkTheme: TsksTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const TsksCustomScrollBehavior(),
    );
  }
}
