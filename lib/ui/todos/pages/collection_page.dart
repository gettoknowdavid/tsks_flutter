import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/ui/core/ui/page_widget.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PageWidget(
      title: 'School',
      showBackButton: true,
    );
  }
}
