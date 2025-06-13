import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PageHeaderWidget extends StatelessWidget {
  const PageHeaderWidget({
    required this.title,
    this.showBackButton = false,
    this.onMoreTap,
    super.key,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        if (showBackButton) ...[
          SizedBox.square(
            dimension: 30,
            child: IconButton.filled(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.maybeOf(context);
                }
              },
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(2),
                shape: const RoundedSuperellipseBorder(
                  borderRadius: BorderRadiusGeometry.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              iconSize: 20,
              icon: const BackButtonIcon(),
            ),
          ),
          const SizedBox(width: 16),
        ],
        Text(title, style: textTheme.titleLarge),
        const Spacer(),
        SizedBox.square(
          dimension: 30,
          child: IconButton(
            onPressed: onMoreTap,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(2),
              shape: const RoundedSuperellipseBorder(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
              ),
            ),
            iconSize: 20,
            icon: const Icon(PhosphorIconsBold.dotsThree),
          ),
        ),
      ],
    );
  }
}
