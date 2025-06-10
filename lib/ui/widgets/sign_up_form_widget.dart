import 'package:flutter/material.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: const InputDecoration(hintText: 'Name'),
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Email'),
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Password'),
        ),
        const SizedBox(height: 40),
        FilledButton(
          onPressed: () {},
          child: const Text('Sign up'),
        ),
      ],
    );
  }
}
