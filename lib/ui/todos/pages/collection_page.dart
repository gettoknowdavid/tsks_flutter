import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/core/ui/page_widget.dart';
import 'package:tsks_flutter/ui/todos/providers/collection/collection_notifier.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(
      collectionNotifierProvider.select((s) => s.collection),
    );

    return PageWidget(
      title: collection.title.getOrCrash,
      showBackButton: true,
      onBackPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          const CollectionsRoute().push<void>(context);
        }
      },
    );
  }
}
