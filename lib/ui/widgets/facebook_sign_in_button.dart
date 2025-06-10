import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FacebookSignInButton extends StatelessWidget {
  const FacebookSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(PhosphorIconsFill.facebookLogo),
      label: const Text('Continue with Facebook'),
    );
  }
}
