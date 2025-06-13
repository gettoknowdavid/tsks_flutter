import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({this.enabled = true, super.key});
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FilledButton(
      onPressed: enabled ? () => Navigator.pop(context) : null,
      style: FilledButton.styleFrom(
        elevation: 0,
        backgroundColor: colors.surfaceContainer,
        foregroundColor: colors.onSurface,
      ),
      child: const Text('Cancel'),
    );
  }
}
