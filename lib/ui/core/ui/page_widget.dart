import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PageWidget extends StatelessWidget {
  const PageWidget({
    required this.title,
    super.key,
    this.showBackButton = false,
    this.onMoreTap,
    this.onBackPressed,
    this.content = const SizedBox.shrink(),
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onMoreTap;
  final VoidCallback? onBackPressed;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return Scaffold(
      appBar: isMobile
          ? PageAppBar(
              showBackButton: showBackButton,
              onBackPressed: onBackPressed,
              title: title,
              onMoreTap: onMoreTap,
            )
          : null,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: MaxWidthBox(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          maxWidth: ResponsiveValue<double>(
            context,
            conditionalValues: [
              const Condition.largerThan(name: MOBILE, value: 620),
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
                  onMoreTap: onMoreTap,
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
    required this.onMoreTap,
    super.key,
  });

  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String title;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? PageBackButton(onBackPressed: onBackPressed)
          : null,
      title: PageTitle(title: title),
      titleSpacing: showBackButton ? 0 : null,
      centerTitle: false,
      actions: [
        PageMoreOptions(onMoreTap: onMoreTap),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PageHeaderWidget extends StatelessWidget {
  const PageHeaderWidget({
    required this.title,
    this.showBackButton = false,
    this.onMoreTap,
    this.onBackPressed,
    super.key,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onMoreTap;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton) ...[
          PageBackButton(onBackPressed: onBackPressed),
          const SizedBox(width: 16),
        ],
        PageTitle(title: title),
        const Spacer(),
        PageMoreOptions(onMoreTap: onMoreTap),
      ],
    );
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(title, style: textTheme.titleLarge);
  }
}

class PageMoreOptions extends StatelessWidget {
  const PageMoreOptions({required this.onMoreTap, super.key});
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
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
    );
  }
}

class PageBackButton extends StatelessWidget {
  const PageBackButton({required this.onBackPressed, super.key});
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final canPop = Navigator.canPop(context);

    if (!canPop) return const SizedBox.shrink();

    return Center(
      child: SizedBox.square(
        dimension: 30,
        child: IconButton.filled(
          onPressed: () {
            if (onBackPressed != null) return onBackPressed?.call();
            if (canPop) return Navigator.pop(context);
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
