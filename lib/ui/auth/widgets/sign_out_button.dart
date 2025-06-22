import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/ui/auth/providers/session.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: ref.read(sessionProvider.notifier).signOut,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
        ),
        child: const Text('Sign out'),
      ),
    );
  }
}
