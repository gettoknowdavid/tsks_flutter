import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/ui/core/ui/page_header_widget.dart';


class PageWidget extends StatelessWidget {
  const PageWidget({
    required this.title,
    super.key,
    this.onMoreTap,
    this.content = const SizedBox.shrink(),
  });

  final String title;
  final VoidCallback? onMoreTap;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: MaxWidthBox(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          maxWidth: ResponsiveValue<double>(
            context,
            conditionalValues: [
              const Condition.largerThan(
                name: TABLET,
                value: 620,
              ),
            ],
            defaultValue: 420,
          ).value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              PageHeaderWidget(title: title, onMoreTap: onMoreTap),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
