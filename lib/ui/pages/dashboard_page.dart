import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';
import 'package:tsks_flutter/ui/pages/loading_page.dart';
import 'package:tsks_flutter/ui/providers/auth/auth.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userChangesProvider);
    return switch (authState) {
      AsyncError(:final error) => Text(error.toString()),
      AsyncData(:final value) =>
        value == User.empty ? const LoadingPage() : const DashboardView(),
      _ => const LoadingPage(),
    };
  }
}

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: Column(children: [Text('Dashboard Page')]));
  }
}
