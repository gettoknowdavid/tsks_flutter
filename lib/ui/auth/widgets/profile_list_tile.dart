import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    required this.title,
    required this.overline,
    required this.actionButtonTitle,
    required this.onActionButtonPressed,
    super.key,
  });

  final String title;
  final String overline;
  final String actionButtonTitle;
  final VoidCallback onActionButtonPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            overline,
            style: textTheme.labelSmall?.copyWith(color: colors.outline),
          ),
          Text(title, style: textTheme.bodyLarge),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: onActionButtonPressed,
        style: ElevatedButton.styleFrom(
          textStyle: textTheme.labelMedium,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
        ),
        child: Text(actionButtonTitle),
      ),
    );
  }
}
