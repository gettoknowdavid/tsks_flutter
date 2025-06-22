import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/data/repositories/auth/auth_repository.dart';
import 'package:tsks_flutter/models/auth/user.dart';
import 'package:tsks_flutter/ui/auth/providers/session.dart';
import 'package:tsks_flutter/ui/core/ui/loading_page.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userChangesProvider);
    return switch (authState) {
      AsyncError(:final error) => Text(error.toString()),
      AsyncData(:final value) =>
        value == User.empty ? const LoadingPage() : const NotificationsView(),
      _ => const LoadingPage(),
    };
  }
}

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Notifications Page'),
          ElevatedButton(
            onPressed: () => ref.read(sessionProvider.notifier).signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
