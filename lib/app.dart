import 'package:flutter/material.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/core/themes/themes.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart' show TsksCustomScrollBehavior;

class TsksApp extends StatelessWidget {
  const TsksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routerConfig,
      theme: TsksTheme.lightTheme,
      darkTheme: TsksTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const TsksCustomScrollBehavior(),
    );
  }
}
