import 'package:flutter/material.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';

class AuthRedirectButton extends StatelessWidget {
  const AuthRedirectButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      spacing: 2,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Dont't have an account?",
          style: TextStyle(color: colors.outline),
        ),
        TextButton(
          onPressed: () => const SignUpRoute().push<void>(context),
          style: TextButton.styleFrom(foregroundColor: colors.onSurfaceVariant),
          child: const Text('Create Account'),
        ),
      ],
    );
  }
}
