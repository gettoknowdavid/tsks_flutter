import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/routing/router.dart';

class PageWidget extends StatelessWidget {
  const PageWidget({
    required this.title,
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
    this.content = const SizedBox.shrink(),
    this.action = const SizedBox.shrink(),
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget content;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return Scaffold(
      appBar: isMobile
          ? PageAppBar(
              showBackButton: showBackButton,
              onBackPressed: onBackPressed,
              title: title,
              action: action,
            )
          : null,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: MaxWidthBox(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          maxWidth: ResponsiveValue<double>(
            context,
            conditionalValues: [
              const Condition.largerThan(name: MOBILE, value: 720),
              const Condition.largerThan(name: DESKTOP, value: 1000),
            ],
            defaultValue: double.infinity,
          ).value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              if (!isMobile) ...[
                PageHeaderWidget(
                  title: title,
                  showBackButton: showBackButton,
                  action: action,
                  onBackPressed: onBackPressed,
                ),
              ],
              content,
            ],
          ),
        ),
      ),
    );
  }
}

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PageAppBar({
    required this.showBackButton,
    required this.onBackPressed,
    required this.title,
    required this.action,
    super.key,
  });

  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String title;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? PageBackButton(onBackPressed: onBackPressed)
          : null,
      title: PageTitle(title),
      titleSpacing: showBackButton ? 0 : null,
      centerTitle: false,
      actions: [action, const SizedBox(width: 16)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PageHeaderWidget extends StatelessWidget {
  const PageHeaderWidget({
    required this.title,
    this.showBackButton = false,
    this.action = const SizedBox.shrink(),
    this.onBackPressed,
    super.key,
  });

  final String title;
  final bool showBackButton;
  final Widget action;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton) ...[
          PageBackButton(onBackPressed: onBackPressed),
          const SizedBox(width: 16),
        ],
        PageTitle(title),
        const Spacer(),
        action,
      ],
    );
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(title, style: textTheme.titleLarge);
  }
}

// class PageMoreOptions extends StatelessWidget {
//   const PageMoreOptions({required this.onMoreTap, super.key});
//   final VoidCallback? onMoreTap;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.square(
//       dimension: 30,
//       child: IconButton(
//         onPressed: onMoreTap,
//         style: IconButton.styleFrom(
//           padding: const EdgeInsets.all(2),
//           shape: const RoundedSuperellipseBorder(
//             borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
//           ),
//         ),
//         iconSize: 20,
//         icon: const Icon(PhosphorIconsBold.dotsThree),
//       ),
//     );
//   }
// }

class PageBackButton extends StatelessWidget {
  const PageBackButton({this.onBackPressed, super.key});

  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final canPop = Navigator.canPop(context);

    return Center(
      child: SizedBox.square(
        dimension: 30,
        child: IconButton.filled(
          onPressed: () {
            if (onBackPressed != null) return onBackPressed?.call();
            if (canPop) {
              return Navigator.pop(context);
            } else {
              const CollectionsRoute().push<void>(context);
            }
          },
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(2),
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            shape: const RoundedSuperellipseBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
            ),
          ),
          iconSize: 20,
          icon: const Icon(PhosphorIconsBold.caretLeft),
        ),
      ),
    );
  }
}
