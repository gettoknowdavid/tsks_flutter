import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FilledButton(
      onPressed: () => Navigator.pop(context),
      style: FilledButton.styleFrom(
        elevation: 0,
        backgroundColor: colors.surfaceContainer,
        foregroundColor: colors.onSurface,
      ),
      child: const Text('Cancel'),
    );
  }
}
